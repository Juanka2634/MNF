% Example:
% segmented_mask = spm_read_vols(spm_vol('mask.nii'));
% fill_in_holes_inside_brain(segmented_mask, 3);
function imgtofill = fill_in_holes_inside_brain(imgtofill, n_passes, bLog)

if ~exist('n_passes','var')
    n_passes = 3;
end
if ~exist('bLog','var')
    bLog = 'off';
end

if (strcmp(bLog, 'on'))
    fprintf('\n> Calling function "fill in wholes inside brain"\n');
end
for ipass = 1:n_passes
    
    %a. get the main cluster only
    CC = bwconncomp(imgtofill,18);
    size_clusters = zeros(CC.NumObjects,1);
    for i = 1:CC.NumObjects
        size_clusters(i,1) = length(CC.PixelIdxList{i});
    end
    [trash,cluster_mask] = max(size_clusters);
    imgtofill = zeros(size(imgtofill));
    imgtofill(CC.PixelIdxList{cluster_mask}) = 1;
    
    %b. if there are holes inside main cluster, fill them in
    CC = bwconncomp(1-imgtofill,18);
    size_clusters = zeros(CC.NumObjects,1);
    if CC.NumObjects > 1
        if (strcmp(bLog, 'on'))
            fprintf('\tPASS %d\tFound 3D holes in this image n = %d\n', ipass, CC.NumObjects);
        end
        for i = 1:CC.NumObjects
            size_clusters(i,1) = length(CC.PixelIdxList{i});
        end
        [size_clusters,IX] = sort(size_clusters,'descend'); % in descending order
        %The first (biggest one) will be the main background cluster
        IX(1) = [];
        for iix = 1:length(IX)
            imgtofill(CC.PixelIdxList{IX(iix)}) = 1;
        end
    end
    
    
    for z = 1:size(imgtofill,3)
        curr_slice = imgtofill(:,:,z);
        CC = bwconncomp(1-imgtofill(:,:,z),8);
        size_clusters = zeros(CC.NumObjects,1);
        if CC.NumObjects > 1
            if (strcmp(bLog, 'on'))
                fprintf('\tPASS %d\tFound z holes in this image n = %d z = %d\n', ipass, CC.NumObjects,z);
            end
            for i = 1:CC.NumObjects
                size_clusters(i,1) = length(CC.PixelIdxList{i});
            end
            [size_clusters,IX] = sort(size_clusters,'descend'); % in descending order
            %The first (biggest one) will be the main background cluster
            IX(1) = [];
            for iix = 1:length(IX)
                if (size_clusters(iix+1) < size_clusters(1)/2) %If the cluster that I'm about to delete is very big, compared to the first cluster, then keep it
                    curr_slice(CC.PixelIdxList{IX(iix)}) = 1;
                end
            end
            imgtofill(:,:,z) = curr_slice;
        end
    end
    
    
    for y = 1:size(imgtofill,2)
        curr_slice = squeeze(imgtofill(:,y,:));
        CC = bwconncomp(1-squeeze(imgtofill(:,y,:)),8);
        size_clusters = zeros(CC.NumObjects,1);
        if CC.NumObjects > 1
            if (strcmp(bLog, 'on'))
                fprintf('\tPASS %d\tFound y holes in this image n = %d y = %d\n', ipass, CC.NumObjects,y);
            end
            for i = 1:CC.NumObjects
                size_clusters(i,1) = length(CC.PixelIdxList{i});
            end
            [size_clusters,IX] = sort(size_clusters,'descend'); % in descending order
            %The first (biggest one) will be the main background cluster
            IX(1) = [];
            for iix = 1:length(IX)
                if (size_clusters(iix+1) < size_clusters(1)/2) %If the cluster that I'm about to delete is very big, compared to the first cluster, then keep it
                    curr_slice(CC.PixelIdxList{IX(iix)}) = 1;
                end
            end
            imgtofill(:,y,:) = curr_slice;
        end
    end
    
    
    for x = 1:size(imgtofill,1)
        curr_slice = squeeze(imgtofill(x,:,:));
        CC = bwconncomp(1-squeeze(imgtofill(x,:,:)),8);
        size_clusters = zeros(CC.NumObjects,1);
        if CC.NumObjects > 1
            if (strcmp(bLog, 'on'))
                fprintf('\tPASS %d\tFound x holes in this image n = %d x = %d\n', ipass, CC.NumObjects,x);
            end
            for i = 1:CC.NumObjects
                size_clusters(i,1) = length(CC.PixelIdxList{i});
            end
            [size_clusters,IX] = sort(size_clusters,'descend'); % in descending order
            %The first (biggest one) will be the main background cluster
            IX(1) = [];
            for iix = 1:length(IX)
                if (size_clusters(iix+1) < size_clusters(1)/2) %If the cluster that I'm about to delete is very big, compared to the first cluster, then keep it
                    curr_slice(CC.PixelIdxList{IX(iix)}) = 1;
                end
            end
            imgtofill(x,:,:) = curr_slice;
        end
    end
    
end

if (strcmp(bLog, 'on'))
    printf('\n> DONE.\n');
end
end