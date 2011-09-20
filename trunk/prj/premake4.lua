
newoption 
{
	trigger		= "without-shared",
	description = "Builds the shared library if supported by the OS"
}

newoption 
{
	trigger		= "with-static",
	description	= "Builds the static library"
}

newoption 
{
	trigger		= "with-debug",
	description	= "Compile for debugging"
}

newoption 
{
	trigger		= "with-demangler",
	description	= "Demangle C++ symbols in backtrace"
}

newoption 
{
	trigger		= "without-bounds",
	description = "Disable runtime bounds checking on stream reads/writes"
}

newoption 
{
	trigger		= "without-fastcopy",
	description	= "Disable specializations for copy/fill"
}

newoption 
{
	trigger		= "without-mmx",
	description	= "Disable use of MMX/SSE/3dNow! instructions"
}

newoption 
{
	trigger		= "force-inline",
	description = "Make inline keyword mean always inline, not just a hint"
}

newoption 
{
	trigger		= "with-libstdc++",
	description = "Link with libstdc++"
} 

PKG_NAME	=	"ustl"
PKG_VERSTR	=	"v1.5" 
PKG_STRING	= PKG_NAME..PKG_VERSTR 
PKG_BUGREPORT = "Mike Sharov <msharov@users.sourceforge.net>"
-- generate config.h
	
newaction 
{
	trigger     = "configure",
	description = "configure",
	
	execute = function ()
		-- copy files, etc. here
		printf("Configuring %s ver %s",PKG_NAME,PKG_VERSTR)
		-- read config.h.in
		local text = ''
		local file = io.open("../config.h.in","r")
		local out = io.open("../config.h","w") 		
	   
		if file == nil then
			print("File not found config.h.in");
			return
		end
	   
		if out == nil then
			print("File not found config.h");
			return
		end
	   
		while true do
			local line = file:read("*l")
			if line == nil then break end
			text = text .. "\n" ..line 
		end
		
		file:close()		
		
		if text == '' then
			print("config.h.in is empty ??")
			return
		end	
		
		text = text:gsub("@PKG_NAME@", PKG_NAME)
		text = text:gsub("@PKG_VERSTR@", PKG_VERSTR)
		text = text:gsub("@PKG_STRING@", PKG_STRING)
		text = text:gsub("@PKG_BUGREPORT@", PKG_BUGREPORT)
		
		text = text:gsub("#undef HAVE_ASSERT_H", "#define HAVE_ASSERT_H 1")
		text = text:gsub("#undef HAVE_ERRNO_H", "#define HAVE_ERRNO_H 1")
		text = text:gsub("#undef HAVE_FLOAT_H", "#define HAVE_FLOAT_H 1")
		text = text:gsub("#undef HAVE_LIMITS_H", "#define HAVE_LIMITS_H 1")
		text = text:gsub("#undef HAVE_STDDEF_H", "#define HAVE_STDDEF_H 1")
		text = text:gsub("#undef HAVE_STDIO_H", "#define HAVE_STDIO_H 1")
		text = text:gsub("#undef HAVE_STDLIB_H", "#define HAVE_STDLIB_H 1")
		
		text = text:gsub("#undef HAVE_CTYPE_H", "#define HAVE_CTYPE_H 1")
		text = text:gsub("#undef HAVE_LOCALE_H", "#define HAVE_LOCALE_H 1" )
		text = text:gsub("#undef HAVE_STRING_H", "#define HAVE_STRING_H 1")
		text = text:gsub("#undef HAVE_TIME_H", "#define HAVE_TIME_H 1")
		text = text:gsub("#undef HAVE_STDARG_H", "#define HAVE_STDARG_H 1")
		text = text:gsub("#undef HAVE_MATH_H", "#define HAVE_MATH_H 1")
		text = text:gsub("#undef HAVE_SIGNAL_H", "#define HAVE_SIGNAL_H 1")
		text = text:gsub("#undef HAVE_SIGNAL_H", "#define HAVE_SIGNAL_H 0")
		text = text:gsub("#undef HAVE_STDINT_H", "#define HAVE_STDINT_H 1")
		
		text = text:gsub("#undef HAVE_INT64_T", "#define HAVE_INT64_T 1")

		text = text:gsub("#define HAVE_VA_COPY 1", "#define HAVE_VA_COPY 0")
		text = text:gsub("#define HAVE_STRSIGNAL 1", "#define HAVE_STRSIGNAL 0")	
		
		text = text:gsub("#define WANT_STREAM_BOUNDS_CHECKING 1", "#define WANT_STREAM_BOUNDS_CHECKING 0")
		text = text:gsub("@BYTE_ORDER@", "LITTLE_ENDIAN")
		-- generate config.h
		out:write(text);
		out:close()	
    end
}


solution "Project"

	language "C++"
	location ( _ACTION )
	flags { "Unicode", "Symbols", "NoMinimalRebuild", "NoEditAndContinue", "NoPCH", "No64BitChecks" }
	targetdir ( "../lib/" .. _ACTION )
	libdirs { "../lib/", "../lib/" .. _ACTION }

	configurations
	{ 
		"Release",
		"Debug"
	}
	
	-- Multithreaded compiling
	if _ACTION == "vs2010" or _ACTION=="vs2008" then
		buildoptions { "/MP"  }
	end 


	
configuration "Release"
	defines { "NDEBUG" }
	flags{ "Optimize", "FloatFast" }
	includedirs { "../" }
	
configuration "Debug"
	defines { "_DEBUG" }
	includedirs { "../" }

project "uStl"
	files { "../*.cc","../*.h"}
	kind "StaticLib"
	flags { StaticRuntime }
	
	configuration "Release"
		targetname( "uStl" )
		
	configuration "Debug"
		targetname( "uStlD" )

project "Bench"		
	files { "../bvt/bench.cc","../bvt/bench.h"}
	kind "ConsoleApp"
	links { "uStl" }
	flags { StaticRuntime }
	
	configuration "Release"
		targetname( "Bench" )
		
	configuration "Debug"
		targetname( "BenchD" )

		
project "Bvt00"		
	files { "../bvt/bvt00.cc","../bvt/stdtest.cc","../bvt/stdtest.h"}
	kind "ConsoleApp"
	links { "uStl" }
	flags { StaticRuntime }
		
	configuration "Release"
		targetname( "Bvt00" )
		
	configuration "Debug"
		targetname( "Bvt00D" )
		
project "Bvt01"		
	files { "../bvt/bvt01.cc","../bvt/stdtest.cc","../bvt/stdtest.h"}
	kind "ConsoleApp"
	links { "uStl" }
	flags { StaticRuntime }
		
	configuration "Release"
		targetname( "Bvt01" )
		
	configuration "Debug"
		targetname( "Bvt01D" )
project "Bvt02"		
	files { "../bvt/bvt02.cc","../bvt/stdtest.cc","../bvt/stdtest.h"}
	kind "ConsoleApp"
	links { "uStl" }
	flags { StaticRuntime }
		
	configuration "Release"
		targetname( "Bvt02" )
		
	configuration "Debug"
		targetname( "Bvt02D" )
		
project "Bvt03"		
	files { "../bvt/bvt03.cc","../bvt/stdtest.cc","../bvt/stdtest.h"}
	kind "ConsoleApp"
	links { "uStl" }
	flags { StaticRuntime }
		
	configuration "Release"
		targetname( "Bvt03" )
		
	configuration "Debug"
		targetname( "Bvt03D" )
		
project "Bvt04"		
	files { "../bvt/bvt04.cc","../bvt/stdtest.cc","../bvt/stdtest.h"}
	kind "ConsoleApp"
	links { "uStl" }
	flags { StaticRuntime }
		
	configuration "Release"
		targetname( "Bvt04" )
		
	configuration "Debug"
		targetname( "Bvt04D" )
		
project "Bvt05"		
	files { "../bvt/bvt05.cc","../bvt/stdtest.cc","../bvt/stdtest.h"}
	kind "ConsoleApp"
	links { "uStl" }
	flags { StaticRuntime }
		
	configuration "Release"
		targetname( "Bvt05" )
		
	configuration "Debug"
		targetname( "Bvt05D" )
		
project "Bvt06"		
	files { "../bvt/bvt06.cc","../bvt/stdtest.cc","../bvt/stdtest.h"}
	kind "ConsoleApp"
	links { "uStl" }
	flags { StaticRuntime }
		
	configuration "Release"
		targetname( "Bvt06" )
		
	configuration "Debug"
		targetname( "Bvt06D" )
		
project "Bvt06"		
	files { "../bvt/bvt06.cc","../bvt/stdtest.cc","../bvt/stdtest.h"}
	kind "ConsoleApp"
	links { "uStl" }
	flags { StaticRuntime }
		
	configuration "Release"
		targetname( "Bvt06" )
		
	configuration "Debug"
		targetname( "Bvt06D" )
		
project "Bvt07"		
	files { "../bvt/bvt07.cc","../bvt/stdtest.cc","../bvt/stdtest.h"}
	kind "ConsoleApp"
	links { "uStl" }
	flags { StaticRuntime }
		
	configuration "Release"
		targetname( "Bvt07" )
		
	configuration "Debug"
		targetname( "Bvt07D" )
		
project "Bvt08"		
	files { "../bvt/bvt08.cc","../bvt/stdtest.cc","../bvt/stdtest.h"}
	kind "ConsoleApp"
	links { "uStl" }
	flags { StaticRuntime }
		
	configuration "Release"
		targetname( "Bvt08" )
		
	configuration "Debug"
		targetname( "Bvt08D" )
		
project "Bvt09"		
	files { "../bvt/bvt09.cc","../bvt/stdtest.cc","../bvt/stdtest.h"}
	kind "ConsoleApp"
	links { "uStl" }
	flags { StaticRuntime }
		
	configuration "Release"
		targetname( "Bvt09" )
		
	configuration "Debug"
		targetname( "Bvt09D" )
		
project "Bvt10"		
	files { "../bvt/bvt10.cc","../bvt/stdtest.cc","../bvt/stdtest.h"}
	kind "ConsoleApp"
	links { "uStl" }
	flags { StaticRuntime }
		
	configuration "Release"
		targetname( "Bvt10" )
		
	configuration "Debug"
		targetname( "Bvt10D" )
		
project "Bvt11"		
	files { "../bvt/bvt11.cc","../bvt/stdtest.cc","../bvt/stdtest.h"}
	kind "ConsoleApp"
	links { "uStl" }
	flags { StaticRuntime }
		
	configuration "Release"
		targetname( "Bvt11" )
		
	configuration "Debug"
		targetname( "Bvt11D" )
		
project "Bvt12"		
	files { "../bvt/bvt12.cc","../bvt/stdtest.cc","../bvt/stdtest.h"}
	kind "ConsoleApp"
	links { "uStl" }
	flags { StaticRuntime }
		
	configuration "Release"
		targetname( "Bvt12" )
		
	configuration "Debug"
		targetname( "Bvt12D" )
		
project "Bvt13"		
	files { "../bvt/bvt13.cc","../bvt/stdtest.cc","../bvt/stdtest.h"}
	kind "ConsoleApp"
	links { "uStl" }
	flags { StaticRuntime }
		
	configuration "Release"
		targetname( "Bvt13" )
		
	configuration "Debug"
		targetname( "Bvt13D" )
		
project "Bvt14"		
	files { "../bvt/bvt14.cc","../bvt/stdtest.cc","../bvt/stdtest.h"}
	kind "ConsoleApp"
	links { "uStl" }
	flags { StaticRuntime }
		
	configuration "Release"
		targetname( "Bvt14" )
		
	configuration "Debug"
		targetname( "Bvt14D" )
		
project "Bvt15"		
	files { "../bvt/bvt15.cc","../bvt/stdtest.cc","../bvt/stdtest.h"}
	kind "ConsoleApp"
	links { "uStl" }
	flags { StaticRuntime }
		
	configuration "Release"
		targetname( "Bvt15" )
		
	configuration "Debug"
		targetname( "Bvt15D" )
		
project "Bvt16"		
	files { "../bvt/bvt16.cc","../bvt/stdtest.cc","../bvt/stdtest.h"}
	kind "ConsoleApp"
	links { "uStl" }
	flags { StaticRuntime }
		
	configuration "Release"
		targetname( "Bvt16" )
		
	configuration "Debug"
		targetname( "Bvt16D" )
		
project "Bvt17"		
	files { "../bvt/bvt17.cc","../bvt/stdtest.cc","../bvt/stdtest.h"}
	kind "ConsoleApp"
	links { "uStl" }
	flags { StaticRuntime }
		
	configuration "Release"
		targetname( "Bvt17" )
		
	configuration "Debug"
		targetname( "Bvt17D" )
		
project "Bvt18"		
	files { "../bvt/bvt18.cc","../bvt/stdtest.cc","../bvt/stdtest.h"}
	kind "ConsoleApp"
	links { "uStl" }
	flags { StaticRuntime }
		
	configuration "Release"
		targetname( "Bvt18" )
		
	configuration "Debug"
		targetname( "Bvt18D" )
project "Bvt19"		
	files { "../bvt/bvt19.cc","../bvt/stdtest.cc","../bvt/stdtest.h"}
	kind "ConsoleApp"
	links { "uStl" }
	flags { StaticRuntime }
		
	configuration "Release"
		targetname( "Bvt19" )
		
	configuration "Debug"
		targetname( "Bvt19D" )
project "Bvt00"		
	files { "../bvt/bvt00.cc","../bvt/stdtest.cc","../bvt/stdtest.h"}
	kind "ConsoleApp"
	links { "uStl" }
	flags { StaticRuntime }
		
	configuration "Release"
		targetname( "Bvt00" )
		
	configuration "Debug"
		targetname( "Bvt00D" )
project "Bvt20"		
	files { "../bvt/bvt20.cc","../bvt/stdtest.cc","../bvt/stdtest.h"}
	kind "ConsoleApp"
	links { "uStl" }
	flags { StaticRuntime }
		
	configuration "Release"
		targetname( "Bvt20" )
		
	configuration "Debug"
		targetname( "Bvt20D" )
project "Bvt21"		
	files { "../bvt/bvt21.cc","../bvt/stdtest.cc","../bvt/stdtest.h"}
	kind "ConsoleApp"
	links { "uStl" }
	flags { StaticRuntime }
		
	configuration "Release"
		targetname( "Bvt21" )
		
	configuration "Debug"
		targetname( "Bvt21D" )
project "Bvt22"		
	files { "../bvt/bvt22.cc","../bvt/stdtest.cc","../bvt/stdtest.h"}
	kind "ConsoleApp"
	links { "uStl" }
	flags { StaticRuntime }
		
	configuration "Release"
		targetname( "Bvt22" )
		
	configuration "Debug"
		targetname( "Bvt22D" )
project "Bvt23"		
	files { "../bvt/bvt23.cc","../bvt/stdtest.cc","../bvt/stdtest.h"}
	kind "ConsoleApp"
	links { "uStl" }
	flags { StaticRuntime }
		
	configuration "Release"
		targetname( "Bvt23" )
		
	configuration "Debug"
		targetname( "Bvt23D" )
project "Bvt24"		
	files { "../bvt/bvt24.cc","../bvt/stdtest.cc","../bvt/stdtest.h"}
	kind "ConsoleApp"
	links { "uStl" }
	flags { StaticRuntime }
		
	configuration "Release"
		targetname( "Bvt24" )
		
	configuration "Debug"
		targetname( "Bvt24D" )
project "Bvt25"		
	files { "../bvt/bvt25.cc","../bvt/stdtest.cc","../bvt/stdtest.h"}
	kind "ConsoleApp"
	links { "uStl" }
	flags { StaticRuntime }
		
	configuration "Release"
		targetname( "Bvt25" )
		
	configuration "Debug"
		targetname( "Bvt25D" )
project "Bvt26"		
	files { "../bvt/bvt26.cc","../bvt/stdtest.cc","../bvt/stdtest.h"}
	kind "ConsoleApp"
	links { "uStl" }
	flags { StaticRuntime }
		
	configuration "Release"
		targetname( "Bvt26" )
		
	configuration "Debug"
		targetname( "Bvt26D" )
project "Bvt27"		
	files { "../bvt/bvt27.cc","../bvt/stdtest.cc","../bvt/stdtest.h"}
	kind "ConsoleApp"
	links { "uStl" }
	flags { StaticRuntime }
		
	configuration "Release"
		targetname( "Bvt27" )
		
	configuration "Debug"
		targetname( "Bvt27D" )
