# The Litle Traveler

This is a drop of some NFT´s with images of a great little traveler. The drop consist of ten images, and five of them are already minted.
The contract is already deploy on rinkeby and is verified as well, the address is:
                                      
                                      0xA7b7E99fd79E396e78466e7FbC1B12343FBF1b20

To interact with the contract on Etherscan first you have to check on the "Read Contract" section the following:

    - The paused variable has to be "false" so you can mint.
    - To change the state of the paused variable, go to the "Write Contract" section and look for the "setPaused" function, change the value, pick write and pay the fee, refresh the page only after the transaction is succesfull.
    - The revealed variable has to be "true" if not you´ll only see a question mark image instead of your token.
    -  To change the state of the revealed variable, go to the "Write Contract" section and look for the "setRevealed" function, change the value, pick write and pay the fee, refresh the page only after the transaction is succesfull.

After this, you can pick the "mint" function and pay for 0.01 ETH. Then you can check on the "Read Contract" in the section "ownerOf" that you are the actual owner. The Tokens 0, 1, 2. 3 and 4 are already minted. Although on tokenURI you can see the metadata link on ipfs.

You can check it on the opensea testnet with the contract address, or with this link: 

https://testnets.opensea.io/collection/the-little-traveler-nmq99kfi9h

