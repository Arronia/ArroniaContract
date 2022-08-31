pragma solidity 0.8.7;

import "ens-contracts/registry/ENS.sol";
import "ens-contracts/registry/ReverseRegistrar.sol";
import "ens-contracts/resolvers/Resolver.sol";
import "../interfaces/IControllerRegistry.sol";
import "../interfaces/IInviteToken.sol";
import "openzeppelin-contracts/access/Ownable.sol";

/**
 * A registrar that allocates subdomains to the first person to claim them.
 */
contract PodEnsRegistrar is Ownable {
    modifier onlyControllerOrOwner() {
        require(
            controllerRegistry.isRegistered(msg.sender) ||
                owner() == msg.sender,
            "sender must be controller/owner"
        );
        _;
    }

    enum State {
        onlySafeWithShip, // Only safes with SHIP token
        onlyShip, // Anyone with SHIP token
        open, // Anyone can enroll
        closed // Nobody can enroll, just in case
    }

    ENS public ens;
    Resolver public resolver;
    ReverseRegistrar public reverseRegistrar;
    IControllerRegistry controllerRegistry;
    bytes32 rootNode;
    IInviteToken inviteToken;
    State public state = State.onlySafeWithShip;

    /**
     * Constructor.
     * @param ensAddr The address of the ENS registry.
     * @param node The node that this registrar administers.
     */
    constructor(
        ENS ensAddr,
        Resolver resolverAddr,
        ReverseRegistrar _reverseRegistrar,
        IControllerRegistry controllerRegistryAddr,
        bytes32 node,
        IInviteToken inviteTokenAddr
    ) {
        require(address(ensAddr) != address(0), "Invalid address");
        require(address(resolverAddr) != address(0), "Invalid address");
        require(address(_reverseRegistrar) != address(0), "Invalid address");
        require(
            address(controllerRegistryAddr) != address(0),
            "Invalid address"
        );
        require(node != bytes32(0), "Invalid node");
        require(address(inviteTokenAddr) != address(0), "Invalid address");

        ens = ensAddr;
        resolver = resolverAddr;
        controllerRegistry = controllerRegistryAddr;
        rootNode = node;
        reverseRegistrar = _reverseRegistrar;
        inviteToken = inviteTokenAddr;
    }
}
