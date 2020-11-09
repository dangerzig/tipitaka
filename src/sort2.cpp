#include "cpp11.hpp"
#include <string>
#include <vector>
#include <iostream>

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

const std::vector<std::string> c_pali_alphabet =
   {"a", "ā", "i", "ī", "u", "ū", "e", "o",
    "k", "kh", "g", "gh", "ṅ",
    "c", "ch", "j", "jh", "ñ",
    "ṭ", "ṭh", "ḍ", "ḍh", "ṇ",
    "t", "th", "d", "dh", "n",
    "p", "ph", "b", "bh", "m",
    "y", "r", "l", "v", "s", "h", "ḷ", "ṃ"};

[[cpp11::register]]
std::vector<std::string> c_explode(std::string s) {
   std::vector<std::string> result;
   result.reserve(s.size());
   int bytes = 0;
   int chars = 0;
   while (bytes < s.size()) {
      std::string next_char = safe_substr(s, chars, 1);
      if (bytes != s.size() - 1 && // not last character
         safe_substr(s, chars + 1, 1) == "h" && // next character is h
         find(c_pali_alphabet.begin(),
               c_pali_alphabet.end(),
               safe_substr(s, chars, 2)) != c_pali_alphabet.end()) { // in Pali alphabet
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


// c is a Pali character (ie, 1 or 2 actual letters)
// returns pali_alphabet.size() + 1 if c is not a valid Pali character
[[cpp11::register]]
int pali_position(std::string c) {
   auto it = find(c_pali_alphabet.begin(),
      c_pali_alphabet.end(), c);
   return distance(c_pali_alphabet.begin(), it);
}



[[cpp11::register]]
bool c_pali_lt(const std::string word1, const std::string word2) {

   // Total bytes in each word
   const auto word1_total_bytes = word1.size();
   const auto word2_total_bytes = word2.size();

   // Bytes compared already
   auto word1_byte_count = 0;
   auto word2_byte_count = 0;

   while (word1_byte_count < word1_total_bytes &&
          word2_byte_count < word2_total_bytes) {

      // How big is the next character in each word?
      const auto word1_next_char_size = char_size(word1, word1_byte_count);
      const auto word2_next_char_size = char_size(word2, word2_byte_count);

      // Get the next character in each word
      std::string word1_next_char =
         word1.substr(word1_byte_count, word1_next_char_size);
      std::string word2_next_char =
         word2.substr(word2_byte_count, word2_next_char_size);

      // What's the byte count to the next character?
      auto word1_next_byte_count = word1_byte_count + word1_next_char_size;
      auto word2_next_byte_count = word2_byte_count + word2_next_char_size;

      // Is there an "h" next in word1? And does that form a valid Pali letter?
      if (word1_next_byte_count < word1_total_bytes &&
          word1.substr(word1_next_byte_count, 1) == "h" &&
          find(c_pali_alphabet.begin(),
               c_pali_alphabet.end(),
               word1.substr(word1_byte_count, word1_next_char_size + 1))
                  != c_pali_alphabet.end()) {

            word1_next_char =
               word1.substr(word1_byte_count, word1_next_char_size + 1);
            word1_next_byte_count++;
      }

      // Same as above for word2.
      if (word2_next_byte_count < word2_total_bytes &&
          word2.substr(word2_next_byte_count, 1) == "h" &&
          find(c_pali_alphabet.begin(),
               c_pali_alphabet.end(),
               word2.substr(word2_byte_count, word2_next_char_size + 1))
             != c_pali_alphabet.end()) {

         word2_next_char =
            word2.substr(word2_byte_count, word2_next_char_size + 1);
         word2_next_byte_count++;
      }
      /* Useful debugging:
      std::cout << "Comparing " << word1_next_char << " and " <<
         word2_next_char << ": " << pali_position(word1_next_char) <<
         " and " << pali_position(word2_next_char) << "\n";
      */

      // If word1 character comes before word2 character, return true.
      if (pali_position(word1_next_char) < pali_position(word2_next_char))
         return true;
      // If word1 character comes after word2 character, return false.
      else if (pali_position(word1_next_char) > pali_position(word2_next_char))
         return false;

      // Otherwise, increment the byte counts and repeat.
      word1_byte_count = word1_next_byte_count;
      word2_byte_count = word2_next_byte_count;

      }

      // If we get all the way through the above while loop,
      // one word is a subset of the other, so the shorter word
      // is less than the longer word.

      if (word1_total_bytes < word2_total_bytes)
         return true;
      else
         return false;
   }


[[cpp11::register]]
bool c_pali_lt_old(const std::string word1, const std::string word2) {
   // wcout << word1 << " " << word2 << "\n";
   const auto temp1 = c_explode(word1);
   const auto temp2 = c_explode(word2);

   for(auto i = 0; i < temp1.size(); i++) {
      if (i > temp2.size()) {
         return(false);
      }
      else if (pali_position(temp1[i]) < pali_position(temp2[i])) {
         return(true);
      }
      else if (pali_position(temp1[i]) > pali_position(temp2[i])) {
         return(false);
      }
   }
   if (temp1.size() < temp2.size()) {
      return(true);
   }
   else {
      return(false);
   }
}

[[cpp11::register]]
std::vector<std::string> c_pali_sort(std::vector<std::string> strings) {
   std::sort(strings.begin(), strings.end(), c_pali_lt);
   return(strings);
}
