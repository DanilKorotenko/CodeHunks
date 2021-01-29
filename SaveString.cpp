/**=================================================================
 * GTB Technologies Proprietary
 * Copyright 2019 GTB Technologies, Inc.
 * UNPUBLISHED WORK
 * This software is the confidential and proprietary information of
 * GTB Technologies, Inc. ("Proprietary Information"). Any use,
 * reproduction, distribution or disclosure of the software or
 * Proprietary Information, in whole or in part, must comply with
 * the terms of the license agreement, nondisclosure agreement
 * or contract entered into with GTB Technologies, Inc. providing
 * access to this software.
 *==================================================================
 */

#include <sstream>
#include <boost/filesystem.hpp>
#include <unistd.h>
#include "JSONPrettify.hpp"

void gtb_save_string_to_original_file(
    const std::string &aFileContent,
    const boost::filesystem::path &aFilePath,
    const std::string &aFileNamePrefix)
{
    std::string filePath = aFilePath.string();

    filePath += "/";
    filePath += aFileNamePrefix;
    filePath += ".XXXXXX";

    char *buf = (char *)malloc(filePath.size());
    strcpy( buf, filePath.c_str() );

    std::string uniquePath = mktemp(buf);

    uniquePath += ".txt";

    free(buf);

    std::ofstream fout(uniquePath);

    fout << aFileContent;

    fout.close();
}

void gtb_save_prettyfied_json_to_original_file(
    const std::string &aJSONContent,
    const boost::filesystem::path &aFilePath,
    const std::string &aFileNamePrefix)
{
    std::string prettyfiedJSON = Agent::JSONPrettify(aJSONContent);

    gtb_save_string_to_original_file(prettyfiedJSON,
        aFilePath, aFileNamePrefix);
}
