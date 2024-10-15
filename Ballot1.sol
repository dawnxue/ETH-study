// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Ballot {
    struct Voter {
        uint256 weight;
        bool voted;
        address delegate;
        uint256 vote;
    }

    struct Proposal {
        bytes32 name;
        uint256 voteCount;
    }

    address public immutable i_chairperson;
    mapping(address => Voter) public voters;
    Proposal[] public proposals;

    uint256 public immutable i_startTime; // 投票开始时间
    uint256 public immutable i_endTime; // 投票结束时间
    uint256 public immutable i_weightSettingEndTime; // 权重设置结束时间

    error Ballot__OnlyChairperson();
    error Ballot__AlreadyVoted();
    error Ballot__NoVotingRights();
    error Ballot__HasVotingRights();
    error Ballot__SelfDelegationNotAllowed();
    error Ballot__FoundLoopInDelegation();
    error Ballot__DelegateHasNoVotingRights();
    error Ballot__VotingNotStarted();
    error Ballot__VotingEnded();
    error Ballot__WeightSettingEnded();
    error Ballot__InvalidWeight();
    error Ballot__InvalidProposal();

    event VoterWeightSet(address indexed voter, uint256 weight);
    event Voted(address indexed voter, uint256 proposalIndex);
    event Delegated(address indexed from, address indexed to);

    /*
     * @dev 构造函数，初始化投票系统
     * @param proposalNames 提案名称数组
     * @param _durationInMinutes 投票持续时间（分钟）
     * @param _weightSettingDurationInMinutes 权重设置持续时间（分钟）
     */
    constructor(
        bytes32[] memory proposalNames,
        uint256 _durationInMinutes,
        uint256 _weightSettingDurationInMinutes
    ) {
        i_chairperson = msg.sender;
        voters[i_chairperson].weight = 1;

        for (uint256 i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({name: proposalNames[i], voteCount: 0}));
        }

        i_startTime = block.timestamp;
        i_endTime = i_startTime + (_durationInMinutes * 1 minutes);
        i_weightSettingEndTime =
            i_startTime +
            (_weightSettingDurationInMinutes * 1 minutes);
    }

    /*
     * @dev 设置选民的投票权重
     * @param voter 选民地址
     * @param weight 要设置的权重
     */
    function setVoterWeight(address voter, uint256 weight) external {
        if (msg.sender != i_chairperson) revert Ballot__OnlyChairperson();
        if (block.timestamp > i_weightSettingEndTime)
            revert Ballot__WeightSettingEnded();
        if (weight == 0) revert Ballot__InvalidWeight();
        if (voters[voter].voted) revert Ballot__AlreadyVoted();

        voters[voter].weight = weight;
        emit VoterWeightSet(voter, weight);
    }
