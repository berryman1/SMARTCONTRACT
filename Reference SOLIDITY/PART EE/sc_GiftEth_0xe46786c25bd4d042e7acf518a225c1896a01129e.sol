/**********************************************************************
*These solidity codes have been obtained from Etherscan for extracting
*the smartcontract related info.
*The data will be used by MATRIX AI team as the reference basis for
*MATRIX model analysis,extraction of contract semantics,
*as well as AI based data analysis, etc.
**********************************************************************/
pragma solidity ^0.4.17;

contract GiftEth {

  event RecipientChanged(address indexed _oldRecipient, address indexed _newRecipient);

  address public gifter;
  address public recipient;
  uint256 public lockTs;
  string public giftMessage;

  function GiftEth(address _gifter, address _recipient, uint256 _lockTs, string _giftMessage) payable public {
    gifter = _gifter;
    recipient = _recipient;
    lockTs = _lockTs;
    giftMessage = _giftMessage;
  }

  function withdraw() public {
    require(msg.sender == recipient);
    require(now >= lockTs);
    msg.sender.transfer(this.balance);
  }

  function changeRecipient(address _newRecipient) public {
    require(msg.sender == recipient);
    RecipientChanged(recipient, _newRecipient);
    recipient = _newRecipient;
  }

}