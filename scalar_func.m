%% scalarizing functions for decomposition methods
function fvalue = scalar_func(y_obj,idealpoint,namda)

global numObjectives 
numObjectives=2;
%% // Tchebycheff approach
% if ~strcmpi(strFunctionType,'_TCH1')
    max_fun = -1.0e+30;
    for n=1:numObjectives
        diff = abs(y_obj(n) - idealpoint(n) );
        if namda(n)==0
            feval = 0.00001*diff;
        else
            feval = diff*namda(n);
        end
        if feval>max_fun
            max_fun = feval;
        end
    end
    fvalue = max_fun;
% end

% %% // normalized Tchebycheff approach
% if ~strcmpi(strFunctionType,'_TCH2')
%     scale=[];
%     for i=1:numObjectives
%         minimun = 1.0e+30;
%         maximun = -1.0e+30;
%         for j=1:numObjectives
%             tp = nbi_node(j).y_obj(i); %???nbi_node???
%             if tp>maximun
%                 maximun = tp;
%             end
%             if tp<minimun
%                 minimun = tp;
%             end
%         end
%         scale=[scale (maximun-minimun)];
%         if maximun-minimun==0
%             fvalue = 1.0e+30;
%         end
%     end
%     max_fun = -1.0e+30;
%     for n=1:numObjectives
%         diff = (y_obj(n) - idealpoint(n))/scale(n);
%         if namda(n)==0
%             feval = 0.0001*diff;
%         else
%             feval = diff*namda(n);
%         end
%         if feval>max_fun
%             max_fun = feval;
%         end
%     end
%     fvalue = max_fun;
% end
% 
% 
% %% //* Boundary intersection approach
% if ~strcmpi(strFunctionType,'_PBI')
%     % // normalize the weight vector (line segment)
%     nd = norm_vector(namda);
%     for i=1:numObjectives
%         namda(i) = namda(i)/nd;
%     end
%     realA=zeros(1,numObjectives);
%     realB=zeros(1,numObjectives);
%     % // difference beween current point and reference point
%     for n=1:numObjectives
%         realA(n) = (y_obj(n) - idealpoint(n));
%     end
%     % // distance along the line segment
%     d1 = abs(innerproduct(realA,namda));
%     % // distance to the line segment
%     for m=1:numObjectives
%         realB(m) = (y_obj(m) - (idealpoint(m) + d1*namda(m)));
%     end
%     d2 = norm_vector(realB);
%     fvalue = d1 + 5*d2;
% end

end

