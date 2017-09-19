classdef HW_LabAssignment1 < handle
% this file contains the class required for the connection to the
% experimental platform.
%
% Version 2.0
% support for multiple connections added, 
% Version 1.1
% 2015 Control course version
%
% contact for questions: forum of the Control Systems course or
% v.spinu@tue.nl
    
    properties
        ipaddress = '172.22.11.2';
        rport = 10005;
        tcpipConnection;
        disturbance = 0;
        reference = 0;
        measured_out = [];
        controller_out = [];
        prefilter_out = [];
        ff_out = [];
        combined_out = [];
        Sfb = 0;
        P = tf(1,1);
        H = tf(1,1);
        F = tf(0,1);
        D = tf(0,1);
        s
        Ts = 250/1e6;
    end
    
    methods
        function obj = createConnection(obj)
            obj.tcpipConnection = tcpip(obj.ipaddress,obj.rport);
            obj.tcpipConnection.InputBufferSize = 5000000;
            obj.tcpipConnection.OutputBufferSize = 5000000;
            fopen(obj.tcpipConnection);
        end
        function obj = CloseConnection(obj)
            fclose(obj.tcpipConnection);
        end
        function obj = uploadDisturbance(obj)
            obj.s = 'dist';
            if(length(obj.disturbance)>20/0.002)
                warning('The disturbance vector is very long. Waveforms longer than 20s may be slow to upload/download and longer than 40s can fail.')
            end
            if(length(obj.reference)~=length(obj.disturbance))
                warning('The length of the disturbance vector and the reference vector do not match')
            end
            for ds = [0;obj.disturbance(:)]
                obj.s = [obj.s,sprintf(';%.8e',ds)];
            end
            obj.s=[obj.s,sprintf('\n')];
            fprintf('\nUploading the disturbance signal\n');
            obj.sendData();

        end
        
        function obj = uploadReference(obj)
            
            obj.s = 'ref';
            if(length(obj.reference)>20/0.002)
                warning('The reference vector is very long. Waveforms longer than 20s may be slow to upload/download and longer than 40s can fail.')
            end
            if(length(obj.reference)~=length(obj.disturbance))
                warning('The length of the disturbance vector and the reference vector do not match')
            end
            for ds = [0;obj.reference(:)]
                obj.s = [obj.s,sprintf(';%.8e',ds)];
            end
            obj.s=[obj.s,sprintf('\n')];
            fprintf('\nUploading the reference signal\n');
            %fopen(obj.tcpipConnection);
            obj.sendData();
            %fclose(obj.tcpipConnection);
        end
        
        function obj = uploadSettings(obj)
            Md = -c2d(obj.H,obj.Ts)/2000/obj.Ts*2*pi; 
            % times the encoder and sampling rate constan, reversed encoder
            Fd = c2d(obj.F,obj.Ts);
            Cd = c2d(obj.D,obj.Ts);
            Pd = c2d(obj.P,obj.Ts);
            
            
            maxorder = max([length(Pd.den{1}),length(Md.den{1}),length(Fd.den{1}),...
                length(Cd.den{1}),]);
            N2nm1 = 2*maxorder-1;
            addrMink = 3*maxorder-1;
            addrRefk = maxorder-1;
            addrErrk = 5*maxorder-1;
            addrFink = 7*maxorder-1;
            
            obj.s = sprintf('\nparam');
            
            %P
            n = Pd.num{1}/Pd.den{1}(1);
            d = Pd.den{1}/Pd.den{1}(1);
            nb = [zeros(1,maxorder-length(n)),n(end:-1:1)];
            db = [zeros(1,maxorder-length(d)),d(end:-1:1)];
            data = [nb,-db];
            %M
            n = Md.num{1}/Md.den{1}(1);
            d = Md.den{1}/Md.den{1}(1);
            nb = [zeros(1,maxorder-length(n)),n(end:-1:1)];
            db = [zeros(1,maxorder-length(d)),d(end:-1:1)];
            data = [data,nb,-db];
            
            % C
                n = Cd.num{1}/Cd.den{1}(1);
            d = Cd.den{1}/Cd.den{1}(1);
            nb = [zeros(1,maxorder-length(n)),n(end:-1:1)];
            db = [zeros(1,maxorder-length(d)),d(end:-1:1)];
            data = [data,nb,-db];
            
            % F
            n = Fd.num{1}/Fd.den{1}(1);
            d = Fd.den{1}/Fd.den{1}(1);
            nb = [zeros(1,maxorder-length(n)),n(end:-1:1)];
            db = [zeros(1,maxorder-length(d)),d(end:-1:1)];
            data = [data,nb,-db];
            
            for ds = data
                obj.s = [obj.s,sprintf(';%.11e',ds)];
            end
            obj.s=[obj.s,sprintf('\n')];
            obj.s = [obj.s,sprintf('settings;0;%.5e;%.5e;%.5e;%.5e;%.5e;%.5e\n'...
                ,addrErrk,N2nm1,addrMink,addrRefk,obj.Ts*1e6,addrFink)];
            fprintf('\nUploading the settings signal\n');
            %fopen(obj.tcpipConnection);
            obj.sendData();
            %fclose(obj.tcpipConnection);
            
        end
        
        function obj = StartExperiment(obj)
            %fopen(obj.tcpipConnection);
            flushinput(obj.tcpipConnection);
            fwrite(obj.tcpipConnection,sprintf('start_exp\n'));
            obj.s = [];
            obj.getdataback();
            %fclose(obj.tcpipConnection);
            fprintf('\nExperiment ended and the data are available\n\n');
        end
        
        function obj = getdataback(obj)
             obj.s = [];
             waittime = 0;
%              fprintf('waiting for the reply : seconds ellapsed xxxxx');
            while waittime <100
               
                if (obj.tcpipConnection.BytesAvailable > 0)
                    buf = fread(obj.tcpipConnection,obj.tcpipConnection.BytesAvailable);
                    obj.s = [obj.s,buf(:)'];
                    %fprintf('bytes received %d\n',size(buf));
                    if(buf(end)==13||buf(end)==10) % \r \n
                        waittime = 100;
                        fprintf('\ncomplete package received\n');
                    end
                else 
                    pause(0.1);

                    if waittime ==0
                    fprintf('waiting for the reply : seconds ellapsed xxx');
                    end
                    waittime = waittime+0.1;
                    fprintf('\b\b\b%03.0f',waittime);

                end
            end
        end
        
        function obj = gety(obj)
%             fopen(obj.tcpipConnection);
            fprintf('\n getting the measured outptut\n\n');
            send_receive_command(obj,'get_y');
            obj.measured_out = parse_s(obj);
%             fclose(obj.tcpipConnection);
        end
        
        function get_all_back(obj)
            % get y back
            fprintf('\n getting the measured outptut\n\n');
            send_receive_command(obj,'get_y');
            obj.measured_out = parse_s(obj);
            % controller out
            fprintf('\n getting the controller outptut\n\n');
            send_receive_command(obj,'get_cout');
            obj.controller_out = parse_s(obj);
            % prefilter out
            fprintf('\n getting the reference filter outptut\n\n')
            send_receive_command(obj,'get_pout');
            obj.prefilter_out = parse_s(obj);
            % feedforward out
            fprintf('\n getting the feed-forward outptut\n\n')
            send_receive_command(obj,'get_fout');
            obj.ff_out = parse_s(obj);
            % complete out
            fprintf('\n getting the combined action\n\n');
            send_receive_command(obj,'get_uout');
            obj.combined_out = parse_s(obj);
        end
        
        function out = parse_s(obj)
            buf = [];
            out = [];
            for c = obj.s;
                if c == sprintf('\r')
                    %         fprintf('\ncompleted\n');
                elseif c == ';'
                    out = [out,sscanf(char(buf),'%e')];
                    buf = [];
                else
                    buf = [buf,c];
                end
            end
        end
        
        function obj = send_receive_command(obj,s)
             %fopen(obj.tcpipConnection);
            fwrite(obj.tcpipConnection,sprintf('%s\n',s));
            obj.s = [];
            obj.getdataback();
            %fclose(obj.tcpipConnection);
        end
        function obj = sendData(obj)
            t = obj.tcpipConnection;
            prc = 0;
            i=1;
            string_to_send = obj.s;
            fprintf('\nuploading progress : xxxx')
            while  length(string_to_send)-i+1 > t.OutputBufferSize-t.BytesToOutput-10
                fwrite(t,string_to_send(i:i+t.OutputBufferSize-t.BytesToOutput-15));
                i = i+t.OutputBufferSize-t.BytesToOutput-15+1;
                prcn = 100*i/length(string_to_send);
                if (prc~=prcn)
                    prc = prcn;
                    fprintf('\b\b\b\b%03.0f%%',prc);
                end
            end
            fwrite(t,string_to_send(i:end));
            fprintf('\b\b\b\b%03.0f%%\n',100);
        end
        function obj = T1(obj)
            if isempty(obj.tcpipConnection)
                obj.createConnection;
            end
            if strcmp(obj.tcpipConnection.Status,'closed')
                    obj.createConnection;
            end
            time = 0:0.002:10;
            obj.uploadSettings;
            obj.disturbance = 0.2*sin(2*pi*time);
            obj.disturbance(1) = 0; 
            obj.reference = time*0+100;
            obj.reference(1) = 0;
            obj.uploadDisturbance;
            obj.uploadReference;
            obj.StartExperiment;
            obj.get_all_back;
            obj.CloseConnection;
        end
        function obj = T2(obj)
            if isempty(obj.tcpipConnection)
                obj.createConnection;
            end
            if strcmp(obj.tcpipConnection.Status,'closed')
                obj.createConnection;
            end
            time = 0:0.002:10;
            obj.uploadSettings;
            obj.disturbance = time*0+0.1;
            obj.disturbance(1) = 0; 
            obj.reference = time*0+200;
            obj.reference(1) = 0;
            obj.uploadDisturbance;
            obj.uploadReference;
            obj.StartExperiment;
            obj.get_all_back;
            obj.CloseConnection;
        end
        function obj = T3(obj)
            if isempty(obj.tcpipConnection)
                obj.createConnection;
            end
            if strcmp(obj.tcpipConnection.Status,'closed')
                    obj.createConnection;
            end
            time = 0:0.002:10;
            obj.uploadSettings;
            obj.disturbance = time*0;
            obj.disturbance(1) = 0; 
            obj.reference = time*0+200;
            index_step = floor(length(time)/2);
            obj.reference(index_step:end) = time(index_step:end)*0-200;
            obj.reference(1) = 0;
            obj.uploadDisturbance;
            obj.uploadReference;
            obj.StartExperiment;
            obj.get_all_back;
            obj.CloseConnection;
        end
    end
    
end


