require("@nomicfoundation/hardhat-toolbox")
require("dotenv").config()

// Go to https://alchemy.com, sign up, create a new App in
// its dashboard, and replace "KEY" with its key
console.log("process env", process.env.FOO)
const ALCHEMY_API_KEY = process.env.ALCHEMY_API_KEY
const SEPOLIA_PRIVATE_KEY = process.env.METAMASK_PRIVATE_KEY

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
	solidity: "0.8.23",
	networks: {
		sepolia: {
			url: `https://eth-sepolia.g.alchemy.com/v2/${ALCHEMY_API_KEY}`,
			accounts: [SEPOLIA_PRIVATE_KEY],
		},
	},
}
