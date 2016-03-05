// <ORACLIZE_API>
/*
Copyright (c) 2015-2016 Oraclize srl, Thomas Bertani



Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:



The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.



THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

contract OraclizeI {
    address public cbAddress;
    function query(uint _timestamp, string _datasource, string _arg) returns (bytes32 _id);
    function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) returns (bytes32 _id);
    function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) returns (bytes32 _id);
    function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) returns (bytes32 _id);
    function getPrice(string _datasource) returns (uint _dsprice);
    function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
    function useCoupon(string _coupon);
    function setProofType(byte _proofType);
}
contract OraclizeAddrResolverI {
    function getAddress() returns (address _addr);
}
contract usingOraclize {
    uint constant day = 60*60*24;
    uint constant week = 60*60*24*7;
    uint constant month = 60*60*24*30;
    byte constant proofType_NONE = 0x00;
    byte constant proofType_TLSNotary = 0x10;
    byte constant proofStorage_IPFS = 0x01;
    uint8 constant networkID_mainnet = 1;
    uint8 constant networkID_testnet = 2;
    uint8 constant networkID_morden = 2;
    uint8 constant networkID_consensys = 161;

    OraclizeAddrResolverI OAR = OraclizeAddrResolverI(0x1d11e5eae3112dbd44f99266872ff1d07c77dce8);

    OraclizeI oraclize;
    modifier oraclizeAPI {
        oraclize = OraclizeI(OAR.getAddress());
        _
    }
    modifier coupon(string code){
        oraclize = OraclizeI(OAR.getAddress());
        oraclize.useCoupon(code);
        _
    }
    function oraclize_setNetwork(uint8 networkID) internal returns(bool){
        if (networkID == networkID_mainnet) OAR = OraclizeAddrResolverI(0x1d11e5eae3112dbd44f99266872ff1d07c77dce8);
        else if (networkID == networkID_testnet) OAR = OraclizeAddrResolverI(0x0ae06d5934fd75d214951eb96633fbd7f9262a7c);
        else if (networkID == networkID_consensys) OAR = OraclizeAddrResolverI(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf);
        else return false;
        return true;
    }
    function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
        return oraclize.query.value(price)(0, datasource, arg);
    }
    function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
        return oraclize.query.value(price)(timestamp, datasource, arg);
    }
    function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
        return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
    }
    function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
        return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
    }
    function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
        return oraclize.query2.value(price)(0, datasource, arg1, arg2);
    }
    function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
        return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
    }
    function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
        return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
    }
    function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
        return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
    }
    function oraclize_cbAddress() oraclizeAPI internal returns (address){
        return oraclize.cbAddress();
    }
    function oraclize_setProof(byte proofP) oraclizeAPI internal {
        return oraclize.setProofType(proofP);
    }



    function parseAddr(string _a) internal returns (address){
        bytes memory tmp = bytes(_a);
        uint160 iaddr = 0;
        uint160 b1;
        uint160 b2;
        for (uint i=2; i<2+2*20; i+=2){
            iaddr *= 256;
            b1 = uint160(tmp[i]);
            b2 = uint160(tmp[i+1]);
            if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
            else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
            if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
            else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
            iaddr += (b1*16+b2);
        }
        return address(iaddr);
    }


    function strCompare(string _a, string _b) internal returns (int) {
        bytes memory a = bytes(_a);
        bytes memory b = bytes(_b);
        uint minLength = a.length;
        if (b.length < minLength) minLength = b.length;
        for (uint i = 0; i < minLength; i ++)
            if (a[i] < b[i])
                return -1;
            else if (a[i] > b[i])
                return 1;
        if (a.length < b.length)
            return -1;
        else if (a.length > b.length)
            return 1;
        else
            return 0;
   }

    function indexOf(string _haystack, string _needle) internal returns (int)
    {
    	bytes memory h = bytes(_haystack);
    	bytes memory n = bytes(_needle);
    	if(h.length < 1 || n.length < 1 || (n.length > h.length))
    		return -1;
    	else if(h.length > (2**128 -1))
    		return -1;
    	else
    	{
    		uint subindex = 0;
    		for (uint i = 0; i < h.length; i ++)
    		{
    			if (h[i] == n[0])
    			{
    				subindex = 1;
    				while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
    				{
    					subindex++;
    				}
    				if(subindex == n.length)
    					return int(i);
    			}
    		}
    		return -1;
    	}
    }

    function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string){
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        bytes memory _bc = bytes(_c);
        bytes memory _bd = bytes(_d);
        bytes memory _be = bytes(_e);
        string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
        bytes memory babcde = bytes(abcde);
        uint k = 0;
        for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
        for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
        for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
        for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
        for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
        return string(babcde);
    }

    function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
        return strConcat(_a, _b, _c, _d, "");
    }

    function strConcat(string _a, string _b, string _c) internal returns (string) {
        return strConcat(_a, _b, _c, "", "");
    }

    function strConcat(string _a, string _b) internal returns (string) {
        return strConcat(_a, _b, "", "", "");
    }

    // parseInt
    function parseInt(string _a) internal returns (uint) {
        return parseInt(_a, 0);
    }

    // parseInt(parseFloat*10^_b)
    function parseInt(string _a, uint _b) internal returns (uint) {
        bytes memory bresult = bytes(_a);
        uint mint = 0;
        bool decimals = false;
        for (uint i=0; i<bresult.length; i++){
            if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
                if (decimals){
                   if (_b == 0) break;
                    else _b--;
                }
                mint *= 10;
                mint += uint(bresult[i]) - 48;
            } else if (bresult[i] == 46) decimals = true;
        }
        return mint;
    }



}
// </ORACLIZE_API>

contract Dice is usingOraclize {

  address admin = 0x0000000000000000000000000000000000000000;
  uint public pwin = 5000; //probability of winning (10000 = 100%)
  uint public edge = 200; //edge percentage (10000 = 100%)
  uint public maxWin = 100; //max win (before edge is taken) as percentage of bankroll (10000 = 100%)
  uint public minBet = 1 ether;
  uint public maxInvestors = 5; //maximum number of investors

  struct Investor {
    address user;
    uint capital;
  }
  mapping(uint => Investor) investors; //starts at 1
  uint public numInvestors = 0;
  mapping(address => uint) investorIDs;
  uint public invested = 0;

  struct Bet {
    address user;
    uint bet;
  }
  mapping (bytes32 => Bet) bets;
  uint public numBets = 0;
  uint public amountWagered = 0;
  int public profit = 0;
  int public takenProfit = 0;

  bytes32 public idTest;
  function Dice(address adminInitial, uint pwinInitial, uint edgeInitial, uint maxWinInitial, uint minBetInitial, uint maxInvestorsInitial) {
    oraclize_setNetwork(networkID_testnet);
    bytes32 id = oraclize_query("URL", "https://www.random.org/integers/?num=1&min=0&max=9999&col=1&base=10&format=plain&rnd=new");
    bets[id] = Bet(0x0000000000000000000000000000000000000000, 0);
    idTest = id;
    admin = adminInitial;
    pwin = pwinInitial;
    edge = edgeInitial;
    maxWin = maxWinInitial;
    minBet = minBetInitial;
    maxInvestors = maxInvestorsInitial;
  }

  function() {
    bet();
  }

  function bet() {
    if (msg.value * 10000 / pwin - msg.value <= maxWin * getBankroll() / 10000 && msg.value>=minBet) {
      if (oraclize.getPrice("URL") < 1 ether) {
        profit -= int(oraclize.getPrice("URL")); //the house pays the oraclize fee
        bytes32 id = oraclize_query("URL", "https://www.random.org/integers/?num=1&min=0&max=9999&col=1&base=10&format=plain&rnd=new");
        bets[id] = Bet(msg.sender, msg.value);
      } else {
        throw; //the fee is too large
      }
    } else {
      throw;
    }
  }

  function __callback(bytes32 id, string result) {
    if (msg.sender != oraclize_cbAddress()) throw;
    if (bets[id].bet>0) {
      uint roll = parseInt(result);
      if (roll <= pwin) { //win
        bets[id].user.send(bets[id].bet * (10000 - edge) / pwin);
        profit += int(bets[id].bet) - int(bets[id].bet * (10000 - edge) / pwin);
      } else { //lose
        bets[id].user.send(1); //send 1 wei
        profit += int(bets[id].bet) - 1;
      }
      numBets++;
      amountWagered += bets[id].bet;
      bets[id].bet = 0;
    }
  }

  function invest() {
    if (investorIDs[msg.sender]>0) {
      rebalance();
      investors[investorIDs[msg.sender]].capital += msg.value;
      invested += msg.value;
    } else {
      rebalance();
      uint investorID = 0;
      if (numInvestors<maxInvestors) {
        investorID = ++numInvestors;
      } else {
        for (uint i=1; i<=numInvestors; i++) {
          if (investors[i].capital<msg.value && investors[i].user!=admin && (investorID==0 || investors[i].capital<investors[investorID].capital)) {
            investorID = i;
          }
        }
      }
      if (investorID>0) {
        if (investors[investorID].capital>0) {
          divest(investors[investorID].user, investors[investorID].capital);
        }
        investorIDs[investors[investorID].user] = 0;
        investors[investorID].user = msg.sender;
        investors[investorID].capital = msg.value;
        invested += msg.value;
        investorIDs[msg.sender] = investorID;
      }
    }
  }

  function rebalance() private {
    uint newInvested = 0;
    uint initialBankroll = getBankroll();
    for (uint i=1; i<=numInvestors; i++) {
      investors[i].capital = getBalance(investors[i].user);
      newInvested += investors[i].capital;
    }
    invested = newInvested;
    if (newInvested != initialBankroll && numInvestors>0) {
      investors[1].capital += (initialBankroll - newInvested); //give the rounding error to the first investor
      invested += (initialBankroll - newInvested);
    }
    takenProfit = profit;
  }

  function divest(address user, uint amount) private {
    if (investorIDs[user]>0) {
      rebalance();
      if (amount>getBalance(user)) {
        amount = getBalance(user);
      }
      investors[investorIDs[user]].capital -= amount;
      invested -= amount;
      if (user.send(amount)) {} else throw;
    }
  }

  function divest(uint amount) {
    if (msg.value>0) throw;
    divest(msg.sender, amount);
  }

  function getBalance(address user) constant returns(uint) {
    if (investorIDs[user]>0 && invested>0) {
      return investors[investorIDs[user]].capital * getBankroll() / invested;
    } else {
      return 0;
    }
  }

  function getBankroll() constant returns(uint) {
    return uint(int(invested)+profit-takenProfit);
  }

  function getStatus() constant returns(uint, uint, uint, uint, uint, uint, int) {
    return (getBankroll(), pwin, edge, maxWin, minBet, amountWagered, profit);
  }

  function changeAdmin(address newAdmin) {
    if (msg.value>0) throw;
    if (msg.sender == admin) {
      admin = newAdmin;
    }
  }

}