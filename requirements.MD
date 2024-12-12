# Software Requirements Specification

## For Tesync

Version 1.0.0

Prepared by Nicolas Ott

# Table of Contents

- [1. Introduction](#1-introduction)
  - [1.1 Document Purpose](#11-document-purpose)
  - [1.2 Product Scope](#12-product-scope)
  - [1.3 Definitions, Acronyms and Abbreviations](#13-definitions-acronyms-and-abbreviations)
  - [1.4 References](#14-references)
  - [1.5 Document Overview](#15-document-overview)
- [2. Product Overview](#2-product-overview)
  - [2.1 Product Perspective](#21-product-perspective)
  - [2.2 Product Functions](#22-product-functions)
  - [2.3 Product Constraints](#23-product-constraints)
  - [2.4 User Characteristics](#24-user-characteristics)
  - [2.5 Assumptions and Dependencies](#25-assumptions-and-dependencies)
  - [2.6 Apportioning of Requirements](#26-apportioning-of-requirements)
- [3. Requirements](#3-requirements)
  - [3.1 User Requirements](#31-user-requirements)
  - [3.2 System Requirements](#32-system-requirements)
- [4. Verification](#4-verification)
- [5. Appendix](#5-appendix)
  - [5.1 Data Sources](#51-data-sources)
  - [5.2 Algorithms and Methodology](#52-algorithms-and-methodology)
  - [5.3 User Interface Design](#53-user-interface-design)
  - [5.4 System Architecture](#54-system-architecture)
  - [5.5 Data Privacy and Security](#55-data-privacy-and-security)
  - [5.6 Testing and Quality Assurance](#56-testing-and-quality-assurance)

# 1. Introduction

## 1.1 Document Purpose

The purpose of this document is to define the requirements for the Tesync software product. It will be used to ensure that the product meets the needs of the users.

## 1.2 Product Scope

Tesync is a mobile application that allows users to sync their Tesla vehicle data to their iPhone and Apple Watch. A significant feature of this product is an improved version of the Tesla "Schedule" feature, which allows users to plan and manage their charging and/or sessions in advance.

## 1.3 Definitions, Acronyms and Abbreviations

- API: Application Programming Interface
- SDK: Software Development Kit
- [Tesla Fleet API](https://developer.tesla.com/docs/fleet-api/getting-started/what-is-fleet-api): The API provided by Tesla that allows developers to access vehicle data and send commands to the vehicle
- [Tesla Vehicle Command SDK](https://github.com/teslamotors/vehicle-command?tab=readme-ov-file): A proxy that allows developers to send commands to the vehicle using the Tesla Fleet API

## 1.4 References

- [Tesla Fleet API](https://developer.tesla.com/docs/fleet-api)
- [Tesla Vehicle Command SDK](https://github.com/teslamotors/vehicle-command?tab=readme-ov-file)
- [SwiftUI](https://developer.apple.com/xcode/swiftui/)
- [.NET](https://dotnet.microsoft.com/en-us/)

## 1.5 Document Overview

This document is organized as follows:

- 2. Product Overview
- 3. Requirements
- 4. Verification
- 5. Appendix

# 2. Product Overview

## 2.1 Product Perspective

Tesync is a mobile application that allows users to sync their Tesla vehicle data to their iPhone and Apple Watch. A significant feature of this product is an improved version of the Tesla "Schedule" feature, which allows users to plan and manage their charging and/or sessions in advance.

## 2.2 Product Functions

- Sync Tesla vehicle data to iPhone and Apple Watch
- Improved version of the Tesla "Schedule" feature
- Plan and manage charging and/or sessions in advance
- Utilize vehicle controls on iPhone and Apple Watch

## 2.3 Product Constraints

While Tesync aims to deliver a seamless experience for users, there are some constraints that must be considered:

- The user must have a Tesla vehicle
- The user must have an iPhone and Apple Watch
- The user must have a Tesla account
- The availability of the Tesla Fleet API

## 2.4 User Characteristics

The primary users of Tesync are Tesla vehicle owners who want to have more control over their vehicle data and charging sessions. These users are tech-savvy and are comfortable using mobile applications.

## 2.5 Assumptions and Dependencies

In developing Tesync, we assume that the Tesla Fleet API will be available and accessible to the application. We also assume that users will have a stable internet connection to sync their vehicle data.

## 2.6 Apportioning of Requirements

Required elements that will be developed in the backend include:

- Storing user data securely.
- managing task scheduling for the user.
- Communicating with the [Tesla Vehicle Command SDK proxy](https://github.com/teslamotors/vehicle-command?tab=readme-ov-file) to send commands to the vehicle.

Required elements that will be developed in the frontend include:

- Interactable vehicle commands
- User-friendly interface for scheduling charging/preconditioning
- Apple Watch integration for quick access to vehicle data and controls.

# 3. Requirements

## 3.1 User Requirements

The user requirements for Tesync are as follows:

- The user must be able to sync their Tesla vehicle data to their iPhone and Apple Watch.
- The user must be able to plan and manage their charging and/or sessions in advance.
- The user must be able to utilize vehicle controls on their iPhone and Apple Watch.

## 3.2 System Requirements

The systems that will be required to use Tesync are as follows:

- Operating System: iOS 14 or later | watchOS 7 or later
- Hardware: iPhone and Apple Watch

# 4. Verification

The verification of Tesync will be done through user testing and feedback. The application will be tested by a group of users who will provide feedback on the usability and functionality of the product.

# 5. Appendix

## 5.1 Data Sources

The data sources for Tesync will be the Tesla Fleet API and the Tesla Vehicle Command SDK.

## 5.2 Algorithms and Methodology

We will use the Tesla Vehicle Command SDK to send commands to the vehicle and the Tesla Fleet API to access vehicle data. Task scheduling will be managed with a custom method that communicates with the Tesla Vehicle Command SDK for a given time.

## 5.3 User Interface Design

The user interface design for Tesync will be developed using SwiftUI for iPhone and Apple Watch.

## 5.4 System Architecture

The system architecture for Tesync will consist of a backend that communicates with the Tesla Fleet API and the Tesla Vehicle Command SDK, and a frontend that displays the user interface and interacts with the backend.

The following technologies will be used:

- Backend: .NET
- Frontend: SwiftUI
- Database: SQLite
- API: Tesla Fleet API
- SDK: Tesla Vehicle Command SDK

## 5.5 Data Privacy and Security

Data privacy and security are of utmost importance for Tesync. User data will be stored securely and encrypted to prevent unauthorized access.

## 5.6 Testing and Quality Assurance

Tesync will undergo rigorous testing and quality assurance to ensure that the product meets the requirements and is free of bugs and issues. Automated testing will be used to test the functionality of the application, and manual testing will be used to test the user experience.
