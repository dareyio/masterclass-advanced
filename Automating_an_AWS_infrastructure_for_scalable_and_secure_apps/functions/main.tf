locals {
    string1 = "darey"
    string2 = "devops"
    string3 = "masterclass"
    string4 = "5498545"
    string5  = "This,is,my,terraform,practice"

    number1 = 054
    number2 = 10989
    number3 = 356

    list1 = ["john", "david", "praise", "dare", "leke"]
    list2 = ["josephine", "ore", "zainab"]
    list3 = ["toba", "timi", "solomon", "feyi", "gabriel"]

    map1 = {
        breakfast = "eba"
        lunch = "salad"
        dinner = "rice"
    }

    cities = {
        lagos = "6.5244° N, 3.3792° E"
        london = "51.5072° N, 0.1276° W"
        mumbai = "19.0760° N, 72.8777° E"
        texas = "31.9686° N, 99.9018° W"
    }

}






// upper(local.string1)
// lower(local.cities.lagos)
// format("Hello, %s!", upper(local.string1))
// split(",", local.string5)
// concat(split(",", local.string5), local.list1)
// index(local.list1, "john")
// index(local.list1, "praise")
// Element - retrieves a single element from a list - element(local.list1, 3)
// upper(element(local.list1, 3))
// keys - takes a map and returns a list containing the keys from that map e.g > keys(local.map1), keys(local.cities) 
// values - returns a list of the values from a map e.g values(local.cities) 
// retrieves the value of a single element from a map, given its key. If the given key does not exist, the given default value is returned instead 
    //  lookup(local.cities, "mumbai", "N/A")
    //    lookup(local.cities, "new york", "Not Available")
