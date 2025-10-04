buildscript {
    repositories {
        google()
        mavenCentral()
        maven(url = "https://github.com/jitsi/jitsi-maven-repository/raw/master/releases")
        maven(url = "https://jitpack.io")
    }
    dependencies {
        classpath("com.google.gms:google-services:4.4.2")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
        maven(url = "https://github.com/jitsi/jitsi-maven-repository/raw/master/releases")
        maven(url = "https://jitpack.io")
    }
}

val usbCameraVersion = "3.3.3"

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

subprojects {
    configurations.all {
        resolutionStrategy.dependencySubstitution {
            substitute(module("com.github.jiangdongguo.AndroidUSBCamera:libnative"))
                .using(module("com.github.jiangdongguo.androidusbcamera:libnative:$usbCameraVersion"))
            substitute(module("com.github.jiangdongguo.AndroidUSBCamera:libuvc"))
                .using(module("com.github.jiangdongguo.androidusbcamera:libuvc:$usbCameraVersion"))
            substitute(module("com.github.jiangdongguo.AndroidUSBCamera:libausbc"))
                .using(module("com.github.jiangdongguo.androidusbcamera:libausbc:$usbCameraVersion"))
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
