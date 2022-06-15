# Nested_Obj_Fetch() function which return Value for particular Key in the object(input to the function)
# input : in_Obj : Nested object
# 		  in_key : Key of object
# output: Value of Key inside in_Obj 
def Nested_Obj_Fetch(in_obj, in_key):
    #create local copy of object to loop through the function
    new_obj = in_obj
    if not isinstance(new_obj,dict):
        return "\"invalid object, provide right input\""
    output = []
    # function to loop through complete object
    def loop(new_obj,in_key):
        #loop through object if its not reached final key
        if not isinstance(new_obj,str):

            for ActualKey,AcutalValue in new_obj.items():
                if ActualKey == in_key:
                    nonlocal output
                    output.append(AcutalValue)
                    return output
                else:
                    new_obj = AcutalValue
                    loop(new_obj,in_key)
        return(output) #return value from loop function
    loop(new_obj,in_key)
    if not output:
        #print("key is not found in the given object")
        return "None"
    else:
        return output

# end of the function

