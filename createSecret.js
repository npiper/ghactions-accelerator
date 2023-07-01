const sodium = require('libsodium-wrappers');

// Get the command line arguments
const publicKeyString = process.argv[2]; // Public key as a string
const plaintextSecret = process.argv[3]; // Plain text secret

// Check if the required arguments are provided
if (!publicKeyString || !plaintextSecret) {
  console.error('Usage: node encrypt.js <public_key_string> <plaintext_secret>');
  process.exit(1);
}

// Check if libsodium is ready and then proceed.
sodium.ready.then(() => {
  // Convert Base64 key to Uint8Array.
  const binkey = sodium.from_base64(publicKeyString, sodium.base64_variants.ORIGINAL);
  const binsec = sodium.from_string(plaintextSecret);

  // Encrypt the secret using LibSodium
  const encBytes = sodium.crypto_box_seal(binsec, binkey);

  // Convert encrypted Uint8Array to Base64
  const output = sodium.to_base64(encBytes, sodium.base64_variants.ORIGINAL);

  console.log(output);
});
