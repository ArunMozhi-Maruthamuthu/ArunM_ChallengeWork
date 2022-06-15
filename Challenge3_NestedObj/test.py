from nested_obj import *
#save the output in text file
with open("output_testresult.txt", "w") as external_file:
    # testing data 1
    emp_list = {"1":{"name":"arun","location":"cbe","mobileno":"9944888466"}, "2":{"name":"subramaniam","location":"namakkal"}}
    #calling function to fetch data for emp_list
    print("Given input object:",emp_list,file=external_file)
    print("========================================================",file=external_file)
    print("output: ",file=external_file)
    #sdel globals()[output]
    value = Nested_Obj_Fetch(emp_list,"location")
    print("value of given key: \"location\" is",value,file=external_file)
    
    value = Nested_Obj_Fetch(emp_list,"mobileno")
    print("value of given key \"mobileno\" is:",value,file=external_file)
    
    value = Nested_Obj_Fetch(emp_list,"tce")
    print("value of given key \"tce\" is:",value,file=external_file)
    
    value = Nested_Obj_Fetch(emp_list,"t")
    print("value of given key \"t\" is:",value,file=external_file)

    value = Nested_Obj_Fetch(emp_list,"2")
    print("value of given key \"2\" is:",value,file=external_file)
    
    print("========================================================",file=external_file)
    #testing data 2
    flowers = {"1":{"name":"jasmine","color":"white"},
                "2":{"name":"rose","color":{"red","yellow","pink"}}}

    print("Given input object:",flowers,file=external_file)
    print("========================================================",file=external_file)
    print("output: ",file=external_file)
    
    value = Nested_Obj_Fetch(flowers,"name")
    print("value of given key: \"name\" is",value,file=external_file)
    
    value = Nested_Obj_Fetch(flowers,"color")
    print("value of given key: \"color\" is",value,file=external_file)
    print("========================================================",file=external_file)
    #testing data 3
    wrong_Obj = ["1","2"]
    print("Given input object:",wrong_Obj,file=external_file)
    print("========================================================",file=external_file)
    print("output: ",file=external_file)

    value = Nested_Obj_Fetch(wrong_Obj,"name")
    print(value,file=external_file)
    external_file.close()