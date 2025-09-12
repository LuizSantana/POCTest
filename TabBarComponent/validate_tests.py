#!/usr/bin/env python3
"""
TabBarComponent UI Tests Validator
This script validates the structure and syntax of UI test files
"""

import os
import re
import subprocess
import sys
from pathlib import Path

class UITestValidator:
    def __init__(self, test_directory):
        self.test_directory = Path(test_directory)
        self.test_files = []
        self.errors = []
        self.warnings = []
        
    def find_test_files(self):
        """Find all UI test Swift files"""
        if not self.test_directory.exists():
            self.errors.append(f"Test directory not found: {self.test_directory}")
            return
            
        for file_path in self.test_directory.glob("*.swift"):
            if file_path.name != "TabBarComponentUITestsLaunchTests.swift":
                self.test_files.append(file_path)
                
    def validate_syntax(self, file_path):
        """Validate Swift syntax using swiftc"""
        try:
            result = subprocess.run(
                ["swiftc", "-parse", str(file_path)],
                capture_output=True,
                text=True,
                timeout=30
            )
            if result.returncode != 0:
                self.errors.append(f"Syntax error in {file_path.name}: {result.stderr}")
                return False
            return True
        except subprocess.TimeoutExpired:
            self.errors.append(f"Timeout parsing {file_path.name}")
            return False
        except FileNotFoundError:
            self.warnings.append("swiftc not found - skipping syntax validation")
            return True
            
    def validate_test_structure(self, file_path):
        """Validate test class structure and methods"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
                
            # Check for test class
            if not re.search(r'class\s+\w+UITests\s*:\s*XCTestCase', content):
                self.errors.append(f"No XCTestCase class found in {file_path.name}")
                return False
                
            # Check for test methods
            test_methods = re.findall(r'func\s+test\w+\(', content)
            if not test_methods:
                self.warnings.append(f"No test methods found in {file_path.name}")
                
            # Check for setUp and tearDown
            if not re.search(r'override\s+func\s+setUpWithError', content):
                self.warnings.append(f"No setUpWithError method in {file_path.name}")
                
            if not re.search(r'override\s+func\s+tearDownWithError', content):
                self.warnings.append(f"No tearDownWithError method in {file_path.name}")
                
            return True
            
        except Exception as e:
            self.errors.append(f"Error reading {file_path.name}: {str(e)}")
            return False
            
    def validate_xcui_elements(self, file_path):
        """Validate XCUIElement usage"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
                
            # Check for common XCUI patterns
            xcui_patterns = [
                r'app\.tabBars',
                r'app\.buttons',
                r'app\.staticTexts',
                r'\.firstMatch',
                r'\.exists',
                r'XCTAssert'
            ]
            
            found_patterns = []
            for pattern in xcui_patterns:
                if re.search(pattern, content):
                    found_patterns.append(pattern)
                    
            if not found_patterns:
                self.warnings.append(f"No XCUI patterns found in {file_path.name}")
                
        except Exception as e:
            self.warnings.append(f"Error validating XCUI elements in {file_path.name}: {str(e)}")
            
    def run_validation(self):
        """Run all validation checks"""
        print("🔍 TabBarComponent UI Tests Validator")
        print("=" * 50)
        
        self.find_test_files()
        
        if not self.test_files:
            print("❌ No test files found")
            return False
            
        print(f"📁 Found {len(self.test_files)} test files:")
        for file_path in self.test_files:
            print(f"   - {file_path.name}")
            
        print("\n🧪 Validating test files...")
        
        all_valid = True
        for file_path in self.test_files:
            print(f"\n📄 Validating {file_path.name}...")
            
            # Syntax validation
            if not self.validate_syntax(file_path):
                all_valid = False
                continue
            else:
                print("   ✅ Syntax valid")
                
            # Structure validation
            if not self.validate_test_structure(file_path):
                all_valid = False
            else:
                print("   ✅ Structure valid")
                
            # XCUI validation
            self.validate_xcui_elements(file_path)
            print("   ✅ XCUI patterns checked")
            
        # Print results
        print("\n" + "=" * 50)
        print("📊 VALIDATION RESULTS")
        print("=" * 50)
        
        if self.errors:
            print(f"\n❌ ERRORS ({len(self.errors)}):")
            for error in self.errors:
                print(f"   - {error}")
                
        if self.warnings:
            print(f"\n⚠️  WARNINGS ({len(self.warnings)}):")
            for warning in self.warnings:
                print(f"   - {warning}")
                
        if not self.errors:
            print("\n✅ All test files are valid!")
            print("🚀 Ready to run UI tests in Xcode")
        else:
            print(f"\n❌ {len(self.errors)} validation errors found")
            all_valid = False
            
        return all_valid

def main():
    # Get test directory
    test_dir = "TabBarComponentUITests"
    if len(sys.argv) > 1:
        test_dir = sys.argv[1]
        
    validator = UITestValidator(test_dir)
    success = validator.run_validation()
    
    sys.exit(0 if success else 1)

if __name__ == "__main__":
    main()
