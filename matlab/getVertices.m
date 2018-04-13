function vertices = getVertices(l,w,h)

vertices = [];
for i = 1:2
    for j = 1:2
        for k = 1:2
            vertices = [vertices;
                        [(l/2)*(-1)^i, (w/2)*(-1)^j, (h/2)*(-1)^k]];
        end
    end
end


end