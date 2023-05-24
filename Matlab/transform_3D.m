function [transformed] = transform_3D(s, x, y, z, th_x, th_y, th_z, dims)

rot_mat = eul2rotm([th_y, th_x, th_z]);
transformed = rot_mat*s;
transformed_x = reshape(transformed(1, :), dims) + x;
transformed_y = reshape(transformed(2, :), dims) + y;
transformed_z = reshape(transformed(3, :), dims) + z;
transformed = cat(3, transformed_x, transformed_y, transformed_z);
end

