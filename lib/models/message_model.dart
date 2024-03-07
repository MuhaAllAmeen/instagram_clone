class Message{
  final String senderID;
  final String recieverID;
  final DateTime timeStamp;
  final String message;

  Message({required this.senderID, required this.recieverID, required this.timeStamp, required this.message});

  Map<String,dynamic> toMap(){
    return {
      'senderID':senderID,
      'recieverID':recieverID,
      'message':message,
      'timestamp':timeStamp
    };
  }
}

