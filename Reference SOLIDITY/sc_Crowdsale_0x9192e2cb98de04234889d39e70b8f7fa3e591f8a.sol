/**********************************************************************
*These solidity codes have been obtained from Etherscan for extracting
*the smartcontract related info.
*The data will be used by MATRIX AI team as the reference basis for
*MATRIX model analysis,extraction of contract semantics,
*as well as AI based data analysis, etc.
**********************************************************************/
pragma solidity ^0.4.15;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
  function mul(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal constant returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal constant returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}


/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() {
    owner = msg.sender;
  }


  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }


  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) onlyOwner {
   require(newOwner != address(0));
   owner = newOwner;
  }

}


/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
contract Pausable is Ownable {
  event Pause();
  event Unpause();

  bool public paused = false;


  /**
   * @dev modifier to allow actions only when the contract IS paused
   */
  modifier whenNotPaused() {
    require(!paused);
    _;
  }

  /**
   * @dev modifier to allow actions only when the contract IS NOT paused
   */
  modifier whenPaused {
    require(paused);
    _;
  }

  /**
   * @dev called by the owner to pause, triggers stopped state
   */
  function pause() onlyOwner whenNotPaused returns (bool) {
    paused = true;
    Pause();
    return true;
  }

  /**
   * @dev called by the owner to unpause, returns to normal state
   */
  function unpause() onlyOwner whenPaused returns (bool) {
    paused = false;
    Unpause();
    return true;
  }
}


/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
  uint256 public totalSupply;
  function balanceOf(address who) constant returns (uint256);
  function transfer(address to, uint256 value) returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}


/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
contract BasicToken is ERC20Basic {
  using SafeMath for uint256;

  mapping(address => uint256) balances;

  /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) returns (bool) {
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) constant returns (uint256 balance) {
    return balances[_owner];
  }

}


/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) constant returns (uint256);
  function transferFrom(address from, address to, uint256 value) returns (bool);
  function approve(address spender, uint256 value) returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}


/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * @dev https://github.com/ethereum/EIPs/issues/20
 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract StandardToken is ERC20, BasicToken {

  mapping (address => mapping (address => uint256)) allowed;


  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amout of tokens to be transfered
   */
  function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
    uint256 _allowance = allowed[_from][msg.sender];

    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
    // require (_value <= _allowance);

    balances[_from] = balances[_from].sub(_value);
    allowed[_from][msg.sender] = _allowance.sub(_value);
    balances[_to] = balances[_to].add(_value);
    Transfer(_from, _to, _value);
    return true;
  }

  /**
   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value) returns (bool) {

    // To change the approve amount you first have to reduce the addresses`
    //  allowance to zero by calling `approve(_spender, 0)` if it is not
    //  already 0 to mitigate the race condition described here:
    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
    require((_value == 0) || (allowed[msg.sender][_spender] == 0));

    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifing the amount of tokens still avaible for the spender.
   */
  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
    return allowed[_owner][_spender];
  }

}


/**
 * Pausable token
 *
 * Simple ERC20 Token example, with pausable token creation
 **/
contract PausableToken is StandardToken, Pausable {

  function transfer(address _to, uint _value) whenNotPaused returns (bool) {
    return super.transfer(_to, _value);
  }

  function transferFrom(address _from, address _to, uint _value) whenNotPaused returns (bool) {
    return super.transferFrom(_from, _to, _value);
  }
}


/**
 * @title RefundVault
 * @dev This contract is used for storing funds while a crowdsale
 * is in progress. Supports refunding the money if crowdsale fails,
 * and forwarding it if crowdsale is successful.
 */
contract RefundVault is Ownable {
  using SafeMath for uint256;

  enum State { Active, Refunding, Closed }

  mapping (address => uint256) public deposited;
  address public wallet;
  State public state;

  event Closed();
  event RefundsEnabled();
  event Refunded(address indexed beneficiary, uint256 weiAmount);

  function RefundVault(address _wallet) {
    require(_wallet != 0x0);
    wallet = _wallet;
    state = State.Active;
  }

  function deposit(address investor) onlyOwner payable {
    require(state == State.Active);
    deposited[investor] = deposited[investor].add(msg.value);
  }

  function close() onlyOwner {
    require(state == State.Active);
    state = State.Closed;
    Closed();
    wallet.transfer(this.balance);
  }

  function enableRefunds() onlyOwner {
    require(state == State.Active);
    state = State.Refunding;
    RefundsEnabled();
  }

  function refund(address investor) {
    require(state == State.Refunding);
    uint256 depositedValue = deposited[investor];
    deposited[investor] = 0;
    investor.transfer(depositedValue);
    Refunded(investor, depositedValue);
  }
}

// @title The TestPCoin
/// @author Manoj Patidar
contract TestPCoin is PausableToken {
   using SafeMath for uint256;

   string public constant name = 'TestPCoin';

   string public constant symbol = 'TESTP';

   uint8 public constant decimals = 18;

   uint256 public  totalSupply = 100e24; // 100M tokens with 18 decimals

   bool public remainingTokenBurnt = false;

   // The tokens already used for the presale buyers
   uint256 public tokensDistributedPresale = 0;

   // The tokens already used for the ICO buyers
   uint256 public tokensDistributedCrowdsale = 0;

   // The address of the crowdsale
   address public crowdsale;

   // The initial supply used for platform and development as specified in the whitepaper
   uint256 public initialSupply = 40e24;

   // The maximum amount of tokens for the presale investors
   uint256 public limitPresale = 10e24;

   // The maximum amount of tokens sold in the crowdsale
   uint256 public limitCrowdsale = 50e24;

   /// @notice Only allows the execution of the function if it's comming from crowdsale
   modifier onlyCrowdsale() {
      require(msg.sender == crowdsale);
      _;
   }

   // When someone refunds tokens
   event RefundedTokens(address indexed user, uint256 tokens);

   /// @notice Constructor used to set the platform & development tokens. This is
   /// The 20% + 20% of the 100 M tokens used for platform and development team.
   /// The owner, msg.sender, is able to do allowance for other contracts. Remember
   /// to use `transferFrom()` if you're allowed
   function TestPCoin() {
      balances[msg.sender] = initialSupply; // 40M tokens wei
   }

   /// @notice Function to set the crowdsale smart contract's address only by the owner of this token
   /// @param _crowdsale The address that will be used
   function setCrowdsaleAddress(address _crowdsale) external onlyOwner whenNotPaused {
      require(_crowdsale != address(0));

      crowdsale = _crowdsale;
   }

   /// @notice Distributes the presale tokens. Only the owner can do this
   /// @param _buyer The address of the buyer
   /// @param tokens The amount of tokens corresponding to that buyer
   function distributePresaleTokens(address _buyer, uint tokens) external onlyOwner whenNotPaused {
      require(_buyer != address(0));
      require(tokens > 0 && tokens <= limitPresale);

      // Check that the limit of 10M presale tokens hasn't been met yet
      require(tokensDistributedPresale < limitPresale);
      require(tokensDistributedPresale.add(tokens) < limitPresale);

      tokensDistributedPresale = tokensDistributedPresale.add(tokens);
      balances[_buyer] = balances[_buyer].add(tokens);
   }

   /// @notice Distributes the ICO tokens. Only the crowdsale address can execute this
   /// @param _buyer The buyer address
   /// @param tokens The amount of tokens to send to that address
   function distributeICOTokens(address _buyer, uint tokens) external onlyCrowdsale whenNotPaused {
      require(_buyer != address(0));
      require(tokens > 0);

      // Check that the limit of 50M ICO tokens hasn't been met yet
      require(tokensDistributedCrowdsale < limitCrowdsale);
      require(tokensDistributedCrowdsale.add(tokens) <= limitCrowdsale);

      tokensDistributedCrowdsale = tokensDistributedCrowdsale.add(tokens);
      balances[_buyer] = balances[_buyer].add(tokens);
   }

   /// @notice Deletes the amount of tokens refunded from that buyer balance
   /// @param _buyer The buyer that wants the refund
   /// @param tokens The tokens to return
   function refundTokens(address _buyer, uint256 tokens) external onlyCrowdsale whenNotPaused {
      require(_buyer != address(0));
      require(tokens > 0);
      require(balances[_buyer] >= tokens);

      balances[_buyer] = balances[_buyer].sub(tokens);
      RefundedTokens(_buyer, tokens);
   }

   /// @notice Burn the amount of tokens remaining after ICO ends
   function burnTokens() external onlyCrowdsale whenNotPaused {

      uint256 remainingICOToken = limitCrowdsale.sub(tokensDistributedCrowdsale);
      if(remainingICOToken > 0 && !remainingTokenBurnt) {
      remainingTokenBurnt = true;
      limitCrowdsale = limitCrowdsale.sub(remainingICOToken);
      totalSupply = totalSupply.sub(remainingICOToken);
      }
   }
}
/// 1. First you set the address of the wallet in the RefundVault contract that will store the deposit of ether
// 2. If the goal is reached, the state of the vault will change and the ether will be sent to the address
// 3. If the goal is not reached , the state of the vault will change to refunding and the users will be able to call claimRefund() to get their ether

/// @author Manoj Patidar <