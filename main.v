import os

fn main() {
    print("Enter your .rgs and .rules file name (no extension, must be all the same name): ")
    mut name := os.get_line()
    os.system("rm -r result")
    os.system("rm -r decompiled")
    os.mkdir("./result/") or { println("Could not create result folder") }
    println("Looking for:")
    println(name + ".rgs")
    if !os.exists("./" + name + ".rgs"){
        println(".rgs file does not exist!")
        return
    }
    println(name + ".rules")
    if !os.exists("./" + name + ".rules"){
        println(".rules file does not exist!")
        return
    }
    /*println(name + ".jar")
    if !os.exists("./" + name + ".jar"){
        println(".jar file does not exist!")
        return
    }
    println("Success, decompiling jar classes...")
    os.system("java -jar ./libs/procyon.jar -o ./decompiled/ ./"+name+".jar >/dev/null")
    os.system("unzip ./" + name + ".jar -d ./decompiled/")*/
    println("Success, creating output...")
    classes := os.read_file("./"+name+".rules") or { panic("Failed to read rules file!") }
    famaa := os.read_file("./"+name+".rgs") or { panic("Failed to read rgs file!") }
    mut txt := ""
    mut params_txt := ""
    for obc in classes.split("\n") {
        if obc.starts_with("rule") {
            txt += "CL: " + obc.split(" ")[1].replace(".", "/") + " " + obc.split(" ")[2].replace(".", "/") + "\n"
            for fomoa in famaa.split("\n") {
                if fomoa.starts_with(".field_map") {
                    // println(fomoa.split(" ")[1] + ".starts_with(" + obc.split(" ")[2].replace(".", "/") + "/" + ")")
                    if fomoa.split(" ")[1].starts_with(obc.split(" ")[2].replace(".", "/") + "/") { 
    txt += "FD: " + fomoa.split(" ")[1].replace(".", "/").replace(obc.split(" ")[2].replace(".", "/"), obc.split(" ")[1].replace(".", "/")) + " " + obc.split(" ")[2].replace(".", "/") + "/" + fomoa.split(" ")[2].replace(".", "/") + "\n"
    }
                }
                if fomoa.starts_with(".method_map") {
                    // println(fomoa.split(" ")[1] + ".starts_with(" + obc.split(" ")[2].replace(".", "/") + "/" + ")")
                    if fomoa.split(" ")[1].starts_with(obc.split(" ")[2].replace(".", "/") + "/") { 
                        mdesc := fomoa.split(" ")[2].replace(".", "/").replace(obc.split(" ")[2].replace(".", "/"), obc.split(" ")[1].replace(".", "/"))
    txt += "MD: " + fomoa.split(" ")[1].replace(".", "/").replace(obc.split(" ")[2].replace(".", "/"), obc.split(" ")[1].replace(".", "/")) + " " + mdesc + " " + obc.split(" ")[2].replace(".", "/") + "/" + fomoa.split(" ")[3].replace(".", "/") + " " + mdesc + "\n"
    }
                }
            }
        }
    }
    println("Writing result to " + name + ".srg")
    os.write_file("./result/"+name+".srg", txt) or { panic("Could not create SRG file!") }
    println("Writing params.exc")
    os.write_file("./result/params.exc", params_txt) or { panic("Could not create params.exc file!") }
    println("Writing javadocs.javadoc")
    os.write_file("./result/javadocs.javadoc", "") or { panic("Could not create javadocs.javadoc file!") }
    println("Done! Enjoy your mappings!")
}
