
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.define("getDayOfCycleUS", function(request, response) {
	//set up to just give back the number of days into the school week.
	//Ex. monday --> 1, friday --> 5, saturday-->0
	/*var weekday = request.params.weekday;
	var weekdayOrdial = request.params.weekdayOrdial;
	var year = request.params.year;
	var month = request.params.month;
	var day = request.params.day;
	
	if(weekday==1||weekday==7){
		response.success(0);
	}
	else if(weekday>1&&weekday<7){
		response.success(weekday-1);
	}
	else{
		response.success(-1);
	}*/
	response.success(4);
});

Parse.Cloud.define("getDayOfCycleMS",function(request, response) {
	response.success(-1);
});

Parse.Cloud.define("requestHangoutNotification",function(request, response) {
	Parse.Cloud.useMasterKey();
	var senderFullName = request.params.senderFullName;
	var messageText = request.params.messageText;
	var recipientObjectId = request.params.recipientObjectId;//"CxL6cXlj6c";
	var senderObjectId = request.params.senderObjectId;
	
	if (senderObjectId != "CxL6cXlj6c" && senderObjectId != "duyoBRdMjx") {
		var profanity = new Array("fuck","shit","pussy","cunt","balls","dick","mom","bitch","faggot"," fag ","slut","cock");
		var messageCopy = messageText.toLowerCase();
		for (var i = 0;i < profanity.length;i++) {
			if(messageCopy.indexOf(profanity[i]) >-1){
				response.error(2);
				return;
			}
		}
	}
	
	var notification = new Parse.Object("Hangouts");
	notification.set("messageText",messageText);
	notification.set("senderFullName",senderFullName);
	notification.set("recipientObjectId",recipientObjectId);
	notification.set("senderObjectId",senderObjectId);
	notification.set("responded",false);
	notification.save(null,{
		success:function(object) {
			//success
		},
		error:function(error) {
			console.log("Error in notification save: "+error);
			response.error(error);
			return;
		}
	});
	
  	var pushQuery = new Parse.Query(Parse.Installation);
	pushQuery.equalTo('channels', recipientObjectId);
	var alertText = senderFullName + " " + messageText;
	var expirationDate = new Date();
	expirationDate.setMilliseconds(0);
	expirationDate.setSeconds(0);
	expirationDate.setMinutes(0);
	expirationDate.setHours(8);//GMT is 7 hours ahead of PDT
	expirationDate.setDate(expirationDate.getDate()+1);
	console.log("expirationDate = " + expirationDate.toString());
	
	Parse.Push.send({
    	where: pushQuery, // Set our Installation query
    	data: {
    		alert: alertText,
    		expiration_time: expirationDate,
    		sound: "",
    		badge:"Increment"
    	}
  	}, {
    	success: function() {
   			response.success(1);
    	},
    	error: function(error) {
      		throw "Got an error " + error.code + " : " + error.message;
    	}
    });
});

Parse.Cloud.define("requestHangoutResponse",function(request,response){
	Parse.Cloud.useMasterKey();
	var senderFullName = request.params.senderFullName;
	var messageText = request.params.messageText;
	var recipientObjectId = request.params.recipientObjectId;//"CxL6cXlj6c";
	var senderObjectId = request.params.senderObjectId;
	var hangoutObjectId = request.params.hangoutObjectId;
	
	var responseObject = new Parse.Object("Responses");
	responseObject.set("messageText",messageText);
	responseObject.set("senderFullName",senderFullName);
	responseObject.set("recipientObjectId",recipientObjectId);
	responseObject.set("senderObjectId",senderObjectId);
	responseObject.set("hangoutObjectId",hangoutObjectId);
	responseObject.save(null,{
		success:function(object) {
			//success
		},
		error:function(error) {
			console.log("Error in response save: "+error);
			response.error(error);
			return;
		}
	});
	
	var pushQuery = new Parse.Query(Parse.Installation);
	pushQuery.equalTo('channels', recipientObjectId);
	var alertText = senderFullName + '\n"' + messageText+'"';
	var expirationDate = new Date();
	expirationDate.setMilliseconds(0);
	expirationDate.setSeconds(0);
	expirationDate.setMinutes(0);
	expirationDate.setHours(8);//GMT is 7 hours ahead of PDT
	expirationDate.setDate(expirationDate.getDate()+1);
	console.log("expirationDate = " + expirationDate.toString());
	
	Parse.Push.send({
    	where: pushQuery, // Set our Installation query
    	data: {
    		alert: alertText,
    		expiration_time: expirationDate,
    		sound: "",
    		badge:"Increment"
    	}
  	}, {
    	success: function() {
    		//query for hangout, set responded to true
    		var hangoutQuery = new Parse.Query("Hangouts");
    		hangoutQuery.equalTo("objectId",hangoutObjectId);
    		hangoutQuery.find({
    			success: function(results){
    				var resultHangout = results[0];
    				console.log("setting responded to true for objectId "+hangoutObjectId);
    				resultHangout.set("responded",true);
    				resultHangout.save(null,{
    					success:function(object) {
    						response.success(1);
    					},
    					error:function(error) {
    			      		throw "Got an error " + error.code + " : " + error.message;
    					}
    				});
    			},
    			error: function(error) {
    				throw "Got an error " + error.code + " : " + error.message;
    			}
    		});
    	},
    	error: function(error) {
      		throw "Got an error " + error.code + " : " + error.message;
    	}
    });
});

Parse.Cloud.beforeDelete("Hangouts", function(request, response) {
	var recipientId = request.object.get("recipientObjectId");
	var userId = request.user.id;
	if(recipientId==userId) {
		response.success();
		return;
	}
	response.error("User validation failed");
});

Parse.Cloud.beforeDelete("Responses", function(request, response) {
	var recipientId = request.object.get("recipientObjectId");
	var userId = request.user.id;
	if(recipientId==userId) {
		response.success();
		return;
	}
	response.error("User validation failed");
});

Parse.Cloud.job("clearHangoutsTable", function(input,status){
	Parse.Cloud.useMasterKey();
	var hangoutCount = -1;
	var query = new Parse.Query("Hangouts");
	query.limit(1000);
	query.notEqualTo("objectId","blah");
	query.find({
		success: function(results){
			hangoutCount = results.length;
			for(x=0;x<hangoutCount;x++){
				console.log("looking at index "+x);
				results[x].destroy({
					success:function(object){},
					error:function(object,error){
						console.log("Error in deleting hangout: "+error);
						status.error();
					}
				});
				
			}
			status.success("removed "+hangoutCount+" hangouts");

		},
		error: function(error){
			console.log("Error in finding hangouts: "+error);
			status.error();
		}
	});
});