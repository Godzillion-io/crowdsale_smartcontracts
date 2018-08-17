/**
*library name : SafeMath
*purpose : be the library for the smart contract for the swap between the godz and ether
*goal : to achieve the secure basic math operations
*/
library SafeMath {

  /*function name : mul*/
  /*purpose : be the funcion for safe multiplicate*/
  function mul(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a * b;
    /*assert(a == 0 || c / a == b);*/
    return c;
  }

  /*function name : div*/
  /*purpose : be the funcion for safe division*/
  function div(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a / b;
    return c;
  }

  /*function name : sub*/
  /*purpose : be the funcion for safe substract*/
  function sub(uint256 a, uint256 b) internal constant returns (uint256) {
    /*assert(b <= a);*/
    return a - b;
  }

  /*function name : add*/
  /*purpose : be the funcion for safe sum*/
  function add(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a + b;
    /*assert(c >= a);*/
    return c;
  }
}