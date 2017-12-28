pragma solidity ^0.4.0;
contract Records {

    struct Record {
        string description;
        uint lifeTime;
    }

    uint numRecords = 0;
    mapping (uint => Record) records;

    // Method for creating new record.
    function newRecord(string text, uint time) public returns (uint recordID) {
        recordID = numRecords++;
        records[recordID] = Record(text, time);
    }

    // Method for getting the description of the element with recordID.
    function getRecordDescription(uint recordID) public view returns (string){
        return records[recordID].description;
    }

    // Method for getting the life time of the element with recordID.
    function getRecordLifeTime(uint recordID) public view returns (uint) {
        return records[recordID].lifeTime;
    }

    // Method for getting the info about the element with recordID.
    function getRecordInfo(uint recordID) public view returns (string, uint){
        return (getRecordDescription(recordID), getRecordLifeTime(recordID));
    }

    // Method for editing the element with recordID. Do nothing if arguments is "" or 0.
    function editRecord(uint recordID, string description, uint lifeTime) public {
        records[recordID].description = (keccak256(description) == keccak256("")) ? records[recordID].description : description;
        records[recordID].lifeTime = (lifeTime == 0) ? records[recordID].lifeTime : lifeTime;
    }

    // Method for deleting the element with recordID.
    function deleteRecord(uint recordID) public {
        delete records[recordID];
        --recordID;
    }
}