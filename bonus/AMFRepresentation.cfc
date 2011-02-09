<cfcomponent extends="taffy.core.genericRepresentation" output="false">
	
	<cfset variables.serializationContext = createObject("java","flex.messaging.io.SerializationContext") />
	<cfset variables.messageIoConstants = createObject("java","flex.messaging.io.MessageIOConstants") />
	
	<cffunction
		name="getAsAMF"
		output="false"
		taffy:mime="application/x-amf"
		taffy:default="true"
		hint="serializes data as AMF (Action Messaging Format) v3">
		
		<cfparam name="variables.data" />

		<cfscript>
			var local = {};
			local.byteStream = createObject("java", "java.io.ByteArrayOutputStream").init();

			local.amfMessage = createObject("java", "flex.messaging.io.amf.MessageBody").init();
			local.amfMessage.setData(variables.data);

			local.requestMessage = createObject("java", "flex.messaging.io.amf.ActionMessage")
								.init(variables.messageIoConstants.AMF3);		
    	local.requestMessage.addBody(amfMessage);
	    
			local.amfMessageSerializer = createObject("java", "flex.messaging.io.amf.AmfMessageSerializer").init();
			local.amfMessageSerializer.initialize(
							variables.serializationContext.getSerializationContext(),
							byteStream,
							createObject("java","flex.messaging.io.amf.AmfTrace").init());
    	local.amfMessageSerializer.writeMessage(local.requestMessage);
			
			local.content = duplicate(local.byteStream);	
			local.byteStream.close();
		</cfscript>

		<cfreturn local.content />
	</cffunction>

</cfcomponent>