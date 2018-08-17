/**
*contract name : GodzSwapGodzEther
*purpose : be the smart contract for the swap between the godz and ether
*goal : to achieve the swap transfers
*/
contract GodzSwapGodzEther  is ReentryProtected{
    address public seller;/*address of the owner of the contract creation*/
    address public tokenContract;/*address of the erc20 token smart contract for the swap*/
    address public complianceContract;/*compliance contract*/
    address public complianceWallet;/*compliance wallet address*/
    uint256 public sellPrice;/*value price of the swap*/
    uint256 public sellQuantity;/*quantity value of the swap*/

    /*function name : GodzSwapGodzEther*/
    /*purpose : be the constructor of the swap smart contract*/
    /*goal : register the basic information of the swap smart contract*/
    function GodzSwapGodzEther(
    address token,
    address complianceC,
    address complianceW
    ){
        tokenContract = token;
        /*owner of the quantity of supply of the erc20 token*/
        seller = msg.sender;
        /*swap price of the token supply*/
        sellPrice = 0.00625 * 1 ether;
        /*total quantity to swap*/
        sellQuantity = SafeMath.mul(210000000, 1 ether);
        /*compliance contract store accounts*/
        complianceContract = complianceC;
        /*compliance wallet holder*/
        complianceWallet = complianceW;
    }

    /*function name : () payable*/
    /*purpose : be the swap executor*/
    /*goal : to transfer the godz to the investor and the ether to the owner of the godz*/
    function() payable preventReentry
    {
        /*address of the buyer*/
        address buyer = msg.sender;

        /*value paid and receive on the swap call*/
        uint256 valuePaid = msg.value;

        /*set the quantity of godz on behalf of the ether that is send to this function*/
  		  uint256 buyQuantity = SafeMath.mul((SafeMath.div(valuePaid, sellPrice)), 1 ether);

        /*gets the balance of the owner of the godz*/
        uint256 balanceSeller = Token(tokenContract).balanceOf(seller);

        /*get the allowance of the owner of the godz*/
  		uint256 balanceAllowed = Token(tokenContract).allowance(seller,this);

        if (seller!=buyer) /*if the seller of godz on swap is different than the investor buying*/
        {
            /*if the balance and the allowance match a valid quantity swap*/
      		if ((balanceAllowed >= buyQuantity) && (balanceSeller >= buyQuantity))
            {
                /*if the msg.value(ether sent) is greater than compliance, store it and sent to the wallet holder*/
                if (valuePaid>(20 * 1 ether))
                {
                    /*transfer the value(ether) to the compliance holder wallet*/
                    complianceWallet.transfer(valuePaid);
                    /*save the account information*/
                    require(GodzSwapGodzEtherCompliance(complianceContract).SaveAccountBuyingGodz(buyer, valuePaid));
                }
                else
                {
                    /*transfer the ether inside to the seller of the godz*/
                    seller.transfer(valuePaid);
                    /*call the transferfrom function of the erc20 token smart contract*/
                    require(Token(tokenContract).transferFrom(seller, buyer, buyQuantity));
                }
            }
            else/*if not a valid match between allowance and balance of the owner of godz, return the ether*/
            {
                /*send back the ether received*/
                buyer.transfer(valuePaid);
            }
        }
    }

    /*function name : safeWithdrawal*/
    /*purpose : be the safe withrow function in case of the contract keep ether inside*/
    /*goal : to transfer the ether to the owner of the swap contract*/
    function safeWithdrawal()
    {
        /*requires that the contract call is the owner of the swap contract*/
        /*require(seller == msg.sender);*/
        /*if the seller of the godz is the call contract address*/
        if (seller == msg.sender)
        {
            /*transfer the ether inside to the seller of the godz*/
            seller.transfer(this.balance);
        }
    }
}