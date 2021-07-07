const Auctions = artifacts.require("Auction");

module.exports = function (deployer) {
  deployer.deploy(Auctions);
};
