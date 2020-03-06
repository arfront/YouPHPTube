<?php
require 'aws/aws-autoloader.php';

use Aws\S3\S3Client;
use Aws\Exception\AwsException;

$KEY = $_ENV['AWS_KEY'];
$SECRET = $_ENV['AWS_SECRET'];
$ARN = $_ENV['AWS_ARN'];
$BUCKET_NAME = uniqid('arfront-');

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

$s3sql = "INSERT INTO plugins (id, uuid, status, created, modified, object_data, name, dirName, pluginversion) VALUES (NULL, '1ddecbec-91db-4357-bb10-ee08b0913778', 'active', now(), now(), '{\"region\":\"cn-northwest-1\",\"bucket_name\":\"{$BUCKET_NAME}\",\"key\":\"{$KEY}\",\"secret\":\"{$SECRET}\",\"endpoint\":\"\",\"profile\":\"\",\"useS3DirectLink\":true,\"presignedRequestSecondsTimeout\":\"43200\",\"CDN_Link\":\"\",\"makeMyFilesPublicRead\":false}', 'AWS_S3', 'AWS_S3', '1.0')";

$sqlfile = fopen("s3.sql", "w");
fwrite($sqlfile, $s3sql);
fclose($sqlfile);