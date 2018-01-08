pragma solidity ^0.4.19;
contract Records {
    
    struct Record {
        string description;
        uint lifeTime;
        
        uint start;
    }

    uint numRecords = 0;
    mapping (uint => Record) records;

    // Method for creating new record.
    function newRecord(string text, uint time) returns(uint recordID) {
        checkRecordsAlive();
        
        recordID = numRecords++; 
        records[recordID] = Record(text, time, now);
    }
    
    // Method for counting records.
    function countRecords() returns(uint) {
        checkRecordsAlive();
        
        return numRecords;
    }
    
    // Method for getting the description of the element with recordID.
    function getRecordDescription(uint recordID) returns(string description) {
        checkRecordsAlive();
        
        return records[recordID].description;
    }
    
    // Method for getting the life time of the element with recordID.
    function getRecordLifeTime(uint recordID) view returns(uint lifeTime) {
        return records[recordID].lifeTime;
    }
    
    // Method for getting the info about the element with recordID.
    function getRecordInfo(uint recordID) returns(string description, uint lifeTime) {
        checkRecordsAlive();
        
        return (getRecordDescription(recordID), getRecordLifeTime(recordID));
    }
    
    // Method for editing the element with recordID. Do nothing if arguments is "" or 0.
    function editRecord(uint recordID, string description, uint lifeTime) public {
        records[recordID].description = (keccak256(description) == keccak256("")) ? records[recordID].description : description;
        records[recordID].lifeTime = (lifeTime == 0) ? records[recordID].lifeTime : lifeTime;
        
        checkRecordsAlive();
    }
    
    // Method for getting all records.
    function getAllRecords() returns(bytes32[3][]) {
        checkRecordsAlive();
           
        uint num = numRecords;
        bytes32[3][] memory res = new bytes32[3][](num);
    
        for (uint i = 0; i < num; ++i) {
            bytes32[] memory desc = StrToBytes32Array(records[i].description);
            bytes32 idIn32format = uintToBytes32(i);
            
            res[i][0] = idIn32format;
            for (uint j = 0; j < desc.length; ++j) {
                res[i][j + 1] = desc[j];
            }
        }
        
        return res;
    }
    
    // Method for deleting elements if their life time ended.
    function checkRecordsAlive() {
        uint num = numRecords;
        
        for (uint i = 0; i < num; ++i) {
            if (records[i].start + records[i].lifeTime > now) {
                deleteRecord(i);
            }
        }
    }
    
    // Method for deleting the element with recordID.
    function deleteRecord(uint recordID) {
        delete records[recordID];
        
        for (uint i = recordID; i < numRecords - 1; ++i) {
            records[i] = records[i + 1];
        }
        
        delete records[numRecords - 1];
        --numRecords;
        
        checkRecordsAlive();
    }
    
    function uintToBytes(uint256 x) constant returns(bytes b) {
        b = new bytes(32);
        assembly { mstore(add(b, 32), x) }
    }
    
    function uintToBytes32(uint256 x) view returns(bytes32 out) {
        for (uint i = 0; i < 32; i++) {
            out |= bytes32(uintToBytes(x)[i] & 0xFF) >> (i * 8);
        }
        
        return out;
    }
    
    // Method for converting string to bytes32[]
    function StrToBytes32Array(string p_str) returns(bytes32[]) {
        bytes  memory lbts_para;  //the result of convert p_str to bytes
        uint li_paralength;   //lbts_para's length
        string memory ls_new; //the result of convert ont bytes32 to string
        bytes32 lbt_row;      // the new bytes32 data  
        bytes32[] storage lbt_result32;    //the return bytes32 array     
        uint li_rowcount; // bytes32 array's length
        uint li_temp;  
        uint li_sum; //the total byte32 array's bytes amount
        uint li_colidx;  //the new column's index
        uint li_resultlength ; // the result bytes32 array's length

        lbts_para = bytes(p_str); //ex:'1234' = 0x31323334
        li_paralength = lbts_para.length;  //ex: 4 
        bytes memory lbts_new = new bytes(32); //for store to arrays32 array
        lbt_result32.length = 0; //ininial the array32 array
        if (li_paralength <= 32) {  //if actul data length is less equal than 32,use assemble method
            assembly {
               lbt_row := mload(add(p_str, 32))
            }
            lbt_result32.length = 1;
            lbt_result32[0] = lbt_row;
        } else {
            //li_rowcount :calculate the bytes32 array's length
            li_rowcount = li_paralength / 32;
            li_temp = li_paralength % 32;
            if (li_temp > 0)
                li_rowcount = li_rowcount + 1;
            //li_sum :the total bytes amount of bytes32 array
            li_sum = li_rowcount * 32;
            li_colidx = 0;
            for (uint p = 1; p <= li_sum; p++){
                //decide whether to add a new row
                li_temp = p%32;  //if equal 0,add a new row
                if (li_temp == 0 ){
                    if (p > li_paralength) 
                        lbts_new[li_colidx] = 0x0;
                    else
                        lbts_new[li_colidx] = lbts_para[p - 1];
                    li_colidx = 0;
                    ls_new = string(lbts_new);
                    assembly {
                        lbt_row := mload(add(ls_new, 32))
                    }
                    li_resultlength = lbt_result32.length ;
                    li_resultlength = li_resultlength + 1;
                    lbt_result32.length = li_resultlength;
                    lbt_result32[li_resultlength - 1] = lbt_row;
                } else {
                    if (p > li_paralength) 
                        lbts_new[li_colidx] = 0x0;
                    else
                        lbts_new[li_colidx] = lbts_para[p - 1];
                    li_colidx = li_colidx + 1;
                }

            }

        }

        return lbt_result32;
    }
}
