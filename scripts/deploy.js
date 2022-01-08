const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory('nft_contract');
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();

    console.log('NFT contract address: ', nftContract.address);
  };
  
  const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.error(error);
      process.exit(1);
    }
  };
  
  runMain();