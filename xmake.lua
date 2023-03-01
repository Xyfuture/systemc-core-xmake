add_rules("mode.debug","mode.release")
--set_config("mode","debug")


option("DISABLE_COPYRIGHT_MESSAGE")
    set_default(false)
    set_showmenu(true)
    add_defines("DISABLE_COPYRIGHT_MESSAGE")

option("ENABLE_ASSERTIONS")
    set_default(true)
    set_showmenu(true)
    add_defines("ENABLE_ASSERTIONS")

option("ENABLE_PTHREADS")
    set_default(false )
    set_showmenu(true)
    add_defines("SC_USE_PTHREADS")

option("DEBUG_SYSTEMC")
    set_default(false)
    set_showmenu(true)
    add_defines("DEBUG_SYSTEMC")


target("systemc")
    set_kind("static")

    set_toolchains("gcc")

    add_options("DISABLE_COPYRIGHT_MESSAGE")
    add_options("ENABLE_ASSERTIONS")
    add_options("ENABLE_PTHREADS")
    
    add_files("sysc/**.cpp")
    add_files("tlm_core/**.cpp")
    add_files("tlm_utils/**.cpp")

    add_includedirs("./",{public=true })
    

    add_headerfiles("(sysc/**.h)","(sysc/**.hpp)","systemc.h","systemc")
    add_headerfiles("(tlm_core/**.h)","(tlm_core/**.hpp)","tlm.h","tlm")
    add_headerfiles("(tlm_utils/**.h)","(tlm_utils/**.hpp)")

    add_defines("SC_BUILD")
    add_defines("SC_INCLUDE_FX")

    set_languages("cxx11")

    add_cxxflags( "-Wextra", "-Wno-unused-parameter" ,"-Wno-unused-variable",{tools={"gcc","clang"}})
    
    -- msvc config 
    --add_cxxflags("/vmg","/MP","/W3","/wd4244","/wd4267","/wd4996", {tools = "cl"})
    --add_defines("_LIB") -- msvc
    
    -- Windows MARCO
    if is_host("windows") then 
        add_defines("WIN32")
    end 

    -- QuickThread support 
    if is_host("linux") then
        if not has_config("ENABLE_PTHREADS") then 
            -- use QuickThread
            add_files("sysc/packages/qt/qt.c")
            if is_arch("x86_64") then 
                add_files("sysc/packages/qt/md/iX86_64.s")
            end 
        else
            -- use Pthread 
            add_links("pthread")
        end 
    end  
