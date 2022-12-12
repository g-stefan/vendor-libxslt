// Created by Grigore Stefan <g_stefan@yahoo.com>
// Public domain (Unlicense) <http://unlicense.org>
// SPDX-FileCopyrightText: 2022 Grigore Stefan <g_stefan@yahoo.com>
// SPDX-License-Identifier: Unlicense

Fabricare.include("vendor.vendor");

if (Shell.fileExists("temp/build.done.flag")) {
	return;
};

if (!Shell.directoryExists("source")) {
	exitIf(Shell.system("7z x -aoa archive/" + Project.vendor + ".7z"));
	Shell.rename(Project.vendor, "source");
};

Shell.mkdirRecursivelyIfNotExists("output");
Shell.mkdirRecursivelyIfNotExists("output/bin");
Shell.mkdirRecursivelyIfNotExists("output/include");
Shell.mkdirRecursivelyIfNotExists("output/lib");
Shell.mkdirRecursivelyIfNotExists("temp");

Shell.mkdirRecursivelyIfNotExists("temp/cmake");

if (!Shell.fileExists("temp/build.config.flag")) {
	Shell.setenv("CC","cl.exe");
	Shell.setenv("CXX","cl.exe");

	cmdConfig="cscript configure.js";
	cmdConfig+=" zlib=yes";
	cmdConfig+=" vcmanifest=yes";
	cmdConfig+=" debug=no";
	cmdConfig+=" static=no";
	cmdConfig+=" xslt_debug=yes";
	cmdConfig+=" bindir="+Shell.realPath(Shell.getcwd())+"\\output\\bin";
	cmdConfig+=" incdir="+Shell.realPath(Shell.getcwd())+"\\output\\include";
	cmdConfig+=" libdir="+Shell.realPath(Shell.getcwd())+"\\output\\lib";
	cmdConfig+=" sodir="+Shell.realPath(Shell.getcwd())+"\\output\\bin";

	runInPath("source\\win32",function(){
		exitIf(Shell.system(cmdConfig));
	});

	Shell.filePutContents("temp/build.config.flag", "done");
};

runInPath("source\\win32",function(){
	exitIf(Shell.system("nmake /f Makefile.msvc"));
	exitIf(Shell.system("nmake /f Makefile.msvc install"));
	exitIf(Shell.system("nmake /f Makefile.msvc clean"));
});

exitIf(!Shell.copyFile("output/lib/libxslt_a.lib", "output/lib/libxslt.static.lib"));

Shell.filePutContents("temp/build.done.flag", "done");
