#include "cpp11.hpp"
#include <string>
#include <vector>
#include <iostream> // just for testing

using namespace cpp11;


std::size_t char_size(const std::string s, int p) {
   if (s.size() < p) return 0;
   std::size_t length = 1;
   while ((s[p + length] & 0b11000000) == 0b10000000) {
      ++length;
   }
   return length;
}

std::string safe_substr(const std::string s, int start, int length) {
   int true_start = 0;
   for (int i = 0; i< start; ++i) {
      true_start += char_size(s, true_start);
   }
   int true_length = 0;
   for (int i = 0; i< length; ++i) {
      true_length += char_size(s, true_start + true_length);
   }
   return s.substr(true_start, true_length);
}

const std::vector<std::string> pali_alphabet =
   {"a", "ā", "i", "ī", "u", "ū", "e", "o",
    "k", "kh", "g", "gh", "ṅ",
    "c", "ch", "j", "jh", "ñ",
    "ṭ", "ṭh", "ḍ", "ḍh", "ṇ",
    "t", "th", "d", "dh", "n",
    "p", "ph", "b", "bh", "m",
    "y", "r", "", "v", "s", "h", "ḷ", "ṃ"};

[[cpp11::register]]
std::vector<std::string> c_explode(std::string s) {
   std::vector<std::string> result;
   int bytes = 0;
   int chars = 0;
   while (bytes < s.size()) {
      std::string next_char = safe_substr(s, chars, 1);
      if (bytes != s.size() - 1 && // not last character
         safe_substr(s, chars + 1, 1) == "h" && // next character is h
         find(pali_alphabet.begin(),
               pali_alphabet.end(),
               safe_substr(s, chars, 2)) != pali_alphabet.end()) { // in Pali alphabet
         result.push_back(safe_substr(s, chars, 2));
         chars += 2;
         bytes += char_size(s, bytes) + 1;
         }
      else {
         result.push_back(next_char);
         chars += 1;
         bytes += char_size(s, bytes);
      }
   }
   return result;
}



