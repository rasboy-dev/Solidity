# Solidity

This is my smart contract. It can CRUD records. Each record has description and life time. The record will be deleted when the life time runs out.

Functions:
getRecordFifeTime(uint ID) - get life time.
getRecordDescription(uint ID) - get description.
getAllRecords() - return all records.
checkRecordsAlive() - find and delete records with elapsed time. Called every transaction (in each function).
countRecords() - number of active records.
deleteRecords(uint ID) - delete record with key = ID.
editRecord(uint ID, string description, uint time) - edit record with key = ID. If description == "", description of records won't be changed, if time == 0 lifeTime won't be changed.
newRecord(string text, uint time) - create new record.
getRecordInfo(uint ID) - get life time and description.
