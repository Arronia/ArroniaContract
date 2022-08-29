pragma solidity ^0.8.7;

interface IControllerBase {
    
    function beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) external;

    function updatePodState(
        uint256 _podId,
        address _podAdmin,
        address _safeAddress
    ) external;
}
