classdef ShapeConstructor < handle
    properties
        particles
        bonds
        
        particlesList
        bondsList
        
        model
    end
    
    methods
        function obj = ShapeConstructor(model_)
            obj.model = model_;
            obj.skeletonize();
        end
        
        
        function bool = isThere(obj, i, j)
            if (i < 1) || (j < 1) || (i > size(obj.model,1)) || (j > size(obj.model,2))
                bool = 0;
            else
                bool = obj.model(i,j);
            end
        end
        
        
        function particle = newParticle(obj,i,j)
            particle = Particle();
            particle.set([i,j], [0,0], 1);
        end
        
        function [n,m] = decodePos(obj, i)
            p = obj.particlesList(i);
            l = size(obj.model, 2)+1;
            n = floor((p-1)/l);
            m = mod(p-1,l) + 1;
        end
        
        function [p] = encodePos(obj, i, j)
            p = i*(size(obj.model,2)+1)+j;
        end
        
        function skeleton = skeletonize(obj)
            n = 0;
            m = 0;
            
            particleMap = containers.Map('KeyType','double','ValueType','double');
            
            for i = 1:size(obj.model,1)
                for j = 1:size(obj.model,2)+1
                    if ~obj.isThere(i,j)
                        if obj.isThere(i,j-1)
                            n = n + 1;
                            particles_(n) = obj.newParticle(i+1,j);
                            particleMap(obj.encodePos(i+1,j)) = n;
                            
                            m = m + 1;
                            iB = particleMap(obj.encodePos(i,j));
                            bonds_(m) = Bond(particles_(n), particles_(iB), 0.5);
                        end
                    else
                        if ~obj.isThere(i,j-1) && ~obj.isThere(i-1, j-1) && ~obj.isThere(i-1,j)
                            n = n + 1;
                            particles_(n) = obj.newParticle(i,j);
                            particleMap(obj.encodePos(i,j)) = n;
                        end
                        
                        if ~obj.isThere(i-1, j+1) && ~obj.isThere(i-1,j)
                            n = n + 1;
                            particles_(n) = obj.newParticle(i,j+1);
                            particleMap(obj.encodePos(i,j+1)) = n;
                        end
                        
                        n = n + 1;
                        particles_(n) = obj.newParticle(i+1,j);
                        particleMap(obj.encodePos(i+1,j)) = n;
                        
                        if ~obj.isThere(i-1,j)
                            m = m + 1;
                            iA = particleMap(obj.encodePos(i,j));
                            iB = particleMap(obj.encodePos(i,j+1));
                            bonds_(m) = Bond(particles_(iA), particles_(iB), 0.5);
                        end
                        
                        m = m + 1;
                        iA = particleMap(obj.encodePos(i,j));
                        iB = particleMap(obj.encodePos(i+1,j));
                        bonds_(m) = Bond(particles_(iA), particles_(iB), 0.5);
                        
                        m = m + 1;
                        iA = particleMap(obj.encodePos(i+1,j));
                        iB = particleMap(obj.encodePos(i,j+1));
                        bonds_(m) = Bond(particles_(iA), particles_(iB), 0.7);
                    end
                    if obj.isThere(i,j-1)
                        m = m + 1;
                        iA = particleMap(obj.encodePos(i+1,j));
                        iB = particleMap(obj.encodePos(i+1,j-1));
                        bonds_(m) = Bond(particles_(iA), particles_(iB), 0.5);
                        
                        m = m + 1;
                        iA = particleMap(obj.encodePos(i+1,j));
                        iB = particleMap(obj.encodePos(i,j-1));
                        bonds_(m) = Bond(particles_(iA), particles_(iB), 0.7);
                    end
                end
                
            end
            if n > 0
                obj.particles = particles_;
                obj.bonds = bonds_;
            end
        end
        
    end
    
end