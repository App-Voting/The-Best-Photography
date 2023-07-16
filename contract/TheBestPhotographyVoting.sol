// SPDX-License-Identifier: GPL-3.0
pragma experimental ABIEncoderV2;
pragma solidity >=0.4.25 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./InitData.sol";

/**
 * @title TheBestPhotography
 * @author Moderate97(^_^)
 * @dev Em-iu-oi-dang-o-dau-day--ve-voi-anh-di
 */
contract TheBestPhotography is Ownable, InitData {

    using SafeERC20 for IERC20;
    mapping(uint256 => mapping(address => uint256)) internal amountPerVoter;
    uint256 public totalVote;

    uint256 private votingStartTime;
    uint256 private votingEndTime;

    uint256 constant REWARD_ARTIST = 500000000 * 10 ** 18;
    uint256 constant REWARD_USER = 500000000 * 10 ** 18;

    IERC20 public TOKEN_VOTING;

    /**
     * @dev Initialize contract
     * @param startTime_ When the voting process will start
     * @param endTime_ When the voting process will end
     */
    constructor(uint256 startTime_, uint256 endTime_, string memory _baseURI) {
        baseURI = _baseURI;
        _initializeData();
        votingStartTime = startTime_;
        votingEndTime = endTime_;
        TOKEN_VOTING = IERC20(0x0000000000000000000000000000000000000000);
    }

    modifier _checkDate() {
        require(block.timestamp >= votingStartTime && block.timestamp <= votingEndTime, "out of date");
        _;
    }

    modifier _isWithdraw() {
        require(block.timestamp > votingEndTime, "event is running");
        _;
    }

    /**
     * @dev Give your vote to potography.
     * @param amountVote number token for voting
     * @param id id of potography
     */
    function vote(
        uint256 amountVote,
        uint256 id
    )
        public
        _checkDate
    {

        amountPerVoter[id][msg.sender] += amountVote;

        imageId[id].amountVote += amountVote;

        totalVote += amountVote;

        TOKEN_VOTING.safeTransferFrom(msg.sender, address(this), amountVote);
    }

    /**
     * @dev used to user withdraw reward and token deposited
     */
    function withdraw() public _isWithdraw
    {
        uint256 idWiner = checkWiner();
        uint256 reward = amountPerVoter[idWiner][msg.sender];
        uint256 rewardPeUserWiner = REWARD_USER / imageId[idWiner].amountVote;
        if(msg.sender == artistId[idWiner]) {
            reward += REWARD_ARTIST;
        }
        if (amountPerVoter[idWiner][msg.sender] > 0) {
            reward += rewardPeUserWiner * amountPerVoter[idWiner][msg.sender];
        }
        TOKEN_VOTING.safeTransferFrom(address(this), artistId[idWiner], reward);
    }

    /**
     * @dev used to return winner
     */
    function checkWiner()
        public view returns (uint256)
    {
        uint256 max = 0;
        uint256 idWiner = 0;
        for (uint256 i = 1; i <= 5; i++) {
            if (imageId[i].amountVote > max) {
                max = imageId[i].amountVote;
                idWiner = i;
            }
        }
        return idWiner;
    }

    /**
     * @dev used to update the voting start & end times
     * @param startTime_ Start time that needs to be updated
     * @param endTime_ End time that needs to be updated
     */
    function updateVotingTime(uint256 startTime_, uint256 endTime_)
        public onlyOwner
    {
        require(startTime_ > endTime_, 'input invalid');
        votingStartTime = startTime_;
        votingEndTime = endTime_;
    }

    function getInfoStateVoting() public view returns (Image[] memory images){
        for (uint256 i = 1; i <= 5; i++) {
            images[i] = imageId[i];
        }
        return images;
    }
}