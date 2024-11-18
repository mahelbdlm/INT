% This function checks if the user is on the right path, or determines the
% relative path to the desired folder
% INPUT: Desired path
% OUTPUT: output.pipeline and output.profile
% Last modification: 14/11/2024

function path=checkPath(targetPath_f)
    currentDir = replace(string(pwd), "\", "/");
    baseIndex = strfind(currentDir, "INT");
    if ~isempty(baseIndex)
        relativeDir = strip(extractAfter(currentDir, baseIndex + strlength("INT")-1), "left", "/");
        if contains(targetPath_f, relativeDir)
            path = strip(erase(targetPath_f, relativeDir), "left", "/");
        else
           throw(MException('mahelcorp:WRONG_PATH_MAHEL', ...
            'You are not on a folder of the path. The path is "%s" and you are in "%s"',targetPath_f, relativeDir));
        end
    else
        throw(MException('mahel_incorporated:WRONG_PATH_INT', ...
            'You are outside the INT folder.'));
    end
    fprintf("Current path is set to: '%s'\n", path);
end