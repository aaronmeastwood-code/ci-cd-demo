const { add } = require('./index');

if (add(2, 3) === 6) {
  console.log("✅ Test passed!");
} else {
  console.error("❌ Test failed!");
  process.exit(1);
}
