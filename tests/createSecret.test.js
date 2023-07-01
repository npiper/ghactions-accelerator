const sodium = require('libsodium-wrappers');
const { execSync } = require('child_process');

// Mock command line arguments
process.argv = ['node', 'createSecret.js', '3mpVyXLsMuudVh3fJ7wS4l2dw20Ppz9fwgbHtAMqS20=', 'secret'];

describe('createSecret', () => {
  beforeAll(async () => {
    await sodium.ready;
  });

  it('should encrypt the secret using LibSodium', () => {
    const publicKeyString = process.argv[2];
    const plaintextSecret = process.argv[3];

    const binkey = sodium.from_base64(publicKeyString, sodium.base64_variants.ORIGINAL);
    const binsec = sodium.from_string(plaintextSecret);

    const encBytes = sodium.crypto_box_seal(binsec, binkey);
    const output = sodium.to_base64(encBytes, sodium.base64_variants.ORIGINAL);

    expect(output).toBeDefined();
    expect(output).not.toEqual('');
  });

  it('should print the encrypted secret to the console and 73 characters long', () => {
    const output = execSync('node createSecret.js 3mpVyXLsMuudVh3fJ7wS4l2dw20Ppz9fwgbHtAMqS20= secret').toString();

    expect(output).toBeDefined();
    expect(output).not.toEqual('');
 
    expect(output.length).toBe(73); // Assert the output length is 73 characters
    expect(output.slice(0, 72)).toMatch(/^[!-~]+$/); // Assert the first 72 characters are printable ASCII characters

 

  });
});
