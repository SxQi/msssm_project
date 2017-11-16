function data = addExitForce(data)
%ADDEXITFORCE add 'exit' attraction force contribution

for fi = 1:data.floor_count

    for ai=1:length(data.floor(fi).agents)
        
        % get agent's data
        p = data.floor(fi).agents(ai).p;
        r = data.floor(fi).agents(ai).r;
        exit = data.floor(fi).agents(ai).exit;
        exitC = data.floor(fi).img_exitC{exit};
        
        e = (exitC - p) * data.meter_per_pixel;
        e = e / norm(e);
        
        % get force
        Fi = [0 0];
        for k = 1 : length(data.floor(fi).img_exit)
            nik = data.floor(fi).img_exitC{k} - p;
            dik = norm(nik);
            nik = nik / dik;
            phi = cos(dot(nik,e));
            if phi < 0
                phi = 0;
            end
            Fi = Fi + (data.C * exp((r - dik)/data.D))*nik*phi;
        end
        
        % add force
        data.floor(fi).agents(ai).f = data.floor(fi).agents(ai).f + Fi;
    end
end

