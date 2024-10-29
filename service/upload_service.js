import { bucket } from '../main.js';

export default async function uploadFile(fileBuffer, destinationPath, mimeType) {
  // Create a reference to the file in the storage bucket
  const blob = bucket.file(destinationPath);

  // Create a writable stream to upload the file
  const blobStream = blob.createWriteStream({
    metadata: {
      contentType: mimeType, // Set the file's MIME type
    },
  });

  // Handle stream errors
  blobStream.on('error', (error) => {
    console.error('Error uploading file:', error);
    throw new Error('Upload failed');
  });

  // Make the file publicly accessible once uploaded
  blobStream.on('finish', async () => {
    await blob.makePublic();
    console.log(`File uploaded to ${destinationPath}`);
  });

  // End the stream with the file buffer
  blobStream.end(fileBuffer);
  
  // Return the public URL of the uploaded file
  return `https://storage.googleapis.com/${bucket.name}/${blob.name}`;
}