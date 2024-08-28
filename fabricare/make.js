// Created by Grigore Stefan <g_stefan@yahoo.com>
// Public domain (Unlicense) <http://unlicense.org>
// SPDX-FileCopyrightText: 2022-2024 Grigore Stefan <g_stefan@yahoo.com>
// SPDX-License-Identifier: Unlicense

Fabricare.include("vendor");

messageAction("make");

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

	Shell.setenv("CC", "cl.exe");
	Shell.setenv("CXX", "cl.exe");

	cmdConfig = "cmake";
	cmdConfig += " ../../source";
	cmdConfig += " -G \"Ninja\"";
	cmdConfig += " -DCMAKE_BUILD_TYPE=Release";
	cmdConfig += " -DCMAKE_INSTALL_PREFIX=" + Shell.realPath(Shell.getcwd()) + "\\output";

	if (Fabricare.isDynamic()) {
		cmdConfig += " -DBUILD_SHARED_LIBS=ON";

		cmdConfig += " -DLIBXSLT_WITH_DEBUGGER=OFF";
		cmdConfig += " -DLIBXSLT_WITH_PYTHON=OFF";
		cmdConfig += " -DLIBXSLT_WITH_TESTS=OFF";
	};

	if (Fabricare.isStatic()) {
		cmdConfig += " -DBUILD_SHARED_LIBS=OFF";
		cmdConfig += " -DWIN32_MT_BUILD=ON";

		cmdConfig += " -DLIBXSLT_WITH_DEBUGGER=OFF";
		cmdConfig += " -DLIBXSLT_WITH_PYTHON=OFF";
		cmdConfig += " -DLIBXSLT_WITH_TESTS=OFF";
	};

	runInPath("temp/cmake", function() {
		exitIf(Shell.system(cmdConfig));
	});

	Shell.filePutContents("temp/build.config.flag", "done");
};

runInPath("temp/cmake", function() {
	exitIf(Shell.system("ninja"));
	exitIf(Shell.system("ninja install"));
	exitIf(Shell.system("ninja clean"));
});

if (Fabricare.isStatic()) {
	exitIf(!Shell.copyFile("output/lib/libexslts.lib", "output/lib/libexslt.lib"));
	exitIf(!Shell.copyFile("output/lib/libxslts.lib", "output/lib/libxslt.lib"));
};

Shell.filePutContents("temp/build.done.flag", "done");
