using Microsoft.SqlServer.Server;
using System.Data.SqlClient;
using System.Data.SqlTypes; 

public class base64Converter
{  
   /* Encodes a string to its base64 equivalent */
   [Microsoft.SqlServer.Server.SqlFunction]
    public static SqlString strToBase64CLR(SqlString toEncode)
    {
		SqlString returnValue = null; 
		if (!toEncode.IsNull) {
			byte[] toEncodeAsBytes = System.Text.ASCIIEncoding.ASCII.GetBytes(toEncode.ToString());
			returnValue = System.Convert.ToBase64String(toEncodeAsBytes);
		}
		return returnValue;
    }  

	/* Decodes a base64 encoded String */ 
	[Microsoft.SqlServer.Server.SqlFunction]
    public static SqlString strFromBase64CLR(SqlString toDecode)
    {
		SqlString returnValue = null;
	 	if (!toDecode.IsNull) {
			byte[] DecodedBytes = System.Convert.FromBase64String(toDecode.ToString());
			returnValue = System.Text.ASCIIEncoding.ASCII.GetString(DecodedBytes);
		}
        return returnValue;
    }
	
	/* Creates a base64 encoded string from a binary value.  
	*/
	[Microsoft.SqlServer.Server.SqlFunction]
    public static SqlString binToBase64CLR(SqlBinary toEncode)
    {
	  SqlString returnValue = null; 
	  if (!toEncode.IsNull) {
         byte[] toEncodeAsBytes = toEncode.Value;
         returnValue = System.Convert.ToBase64String(toEncodeAsBytes); 
	  }
      return returnValue;
    } 
 	
	/* Coverts a base64 encoded string to its binary value.  
	*/ 
	[Microsoft.SqlServer.Server.SqlFunction]
    public static SqlBinary binFromBase64CLR(SqlString toDecode)
    {
		SqlBinary result = null; 
		if (!toDecode.IsNull) { 
			byte[] DecodedBytes = System.Convert.FromBase64String(toDecode.ToString());
			result = new SqlBinary(DecodedBytes);
		}
		return result; 
    }
}