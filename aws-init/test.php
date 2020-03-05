<?php
require 'aws/aws-autoloader.php';

use Aws\S3\S3Client;
use Aws\Exception\AwsException;

$KEY = 'AKIA6E2GEODUOVRFWGPT';
$SECRET = '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';

// 存储桶名称需要获取环境变量的值,存储桶必须唯一，起名时需要加前缀
$BUCKET_NAME = 'youphptube-bucket1';

// Create a S3Client
$credentials = new Aws\Credentials\Credentials($KEY, $SECRET);
$s3Client = new Aws\S3\S3Client([
    'version'     => 'latest',
    'region'      => 'cn-northwest-1',
    'credentials' => $credentials
]);

// Scan all S3 Bucket
$buckets = $s3Client->listBuckets();
foreach ($buckets['Buckets'] as $bucket) {
    if ($bucket['Name'] == $BUCKET_NAME) {
        echo "Bucket already exists";
        exit;
    }
}

// Creating S3 Bucket
try {
    $result = $s3Client->createBucket([
        'Bucket' => $BUCKET_NAME,
    ]);
} catch (AwsException $e) {
    // output error message if fails
    echo $e->getMessage();
    echo "\n";
}

// Make a policy
$policy = [
    'Statement' => [
            [
            'Action' => [
                's3:*'
            ],
            'Effect' => 'Allow',
            'Resource' => [
                "arn:aws-cn:s3:::{$BUCKET_NAME}"
            ],
            'Principal' => [
                'AWS' => [
                    //arn值与key、secret来源一致
                    'arn:aws-cn:iam::972420313320:user/youphptube',
                ]
            ]
        ]
    ]
];

// Replaces a policy on the bucket
try {
    $resp = $s3Client->putBucketPolicy([
        'Bucket' => $BUCKET_NAME,
        'Policy' => json_encode($policy),
    ]);
    //echo "Succeed in put a policy on bucket: " . $BUCKET_NAME . "\n";
} catch (AwsException $e) {
    // Display error message
    echo $e->getMessage();
    echo "\n";
}



