pragma solidity ^0.5.0;

import "./Bank.sol";
import "@optionality.io/clone-factory/contracts/CloneFactory.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";


contract BankFactory is Ownable, CloneFactory {

  /*Variables*/
  struct BankTag {
    address bankAddress;
  }

  address public bankAddress;
  BankTag[] private _banks;

  event BankCreated(address newBankAddress, address owner);

  constructor(address _bankAddress) public {
    bankAddress = _bankAddress;
  }

  function createBank(
    string memory name,
    uint256 interestRate,
    uint256 originationFee,
    uint256 collateralizationRatio,
    uint256 liquidationPenalty,
    uint256 period,
    address payable oracleAddress) public returns(address) {

    address clone = createClone(bankAddress);
    Bank(clone).init(msg.sender, name, interestRate, originationFee,
      collateralizationRatio, liquidationPenalty, period,
      owner(), oracleAddress);
    BankTag memory newBankTag = BankTag(clone);
    _banks.push(newBankTag);
    emit BankCreated(clone, msg.sender);
  }

  function getNumberOfBanks() public view returns (uint256){
    return _banks.length;
  }

  function getBankAddressAtIndex(uint256 index) public view returns (address){
    BankTag storage bank = _banks[index];
    return bank.bankAddress;
  }

}
