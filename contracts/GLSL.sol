// SPDX-License-Identifier: AGPL-1.0
pragma solidity 0.8.9;

import "./ERC721Base.sol";
import "base64-sol/base64.sol";

contract SimpleERC721 is ERC721Base {
    uint256 _lastId;

    function uint2str(uint256 num) private pure returns (string memory _uintAsString) {
        unchecked {
            if (num == 0) {
                return "0";
            }

            uint256 j = num;
            uint256 len;
            while (j != 0) {
                len++;
                j /= 10;
            }

            bytes memory bstr = new bytes(len);
            uint256 k = len - 1;
            while (num != 0) {
                bstr[k--] = bytes1(uint8(48 + (num % 10)));
                num /= 10;
            }

            return string(bstr);
        }
    }

    function tokenURI(uint256 tokenId) external view returns (string memory) {
        string memory tokenIdStr = uint2str(tokenId);
        return
            string(
                abi.encodePacked(
                    // solhint-disable quotes
                    'data:text/plain,{"name":"Token ',
                    tokenIdStr,
                    '","description":"Token ',
                    tokenIdStr,
                    '","image":"data:image/svg+xml;base64,',
                    Base64.encode(
                        abi.encodePacked(
                            "<svg viewBox='0 0 32 16' xmlns='http://www.w3.org/2000/svg'><text x='50%' y='50%' dominant-baseline='middle' text-anchor='middle' style='fill: rgb(219, 39, 119); font-size: 12px;'> Hello ",
                            tokenIdStr,
                            "</text></svg>"
                        )
                    ),
                    '","animation_url":"data:text/html;base64,',
                    Base64.encode(
                        abi.encodePacked(

                            "<html><style>body{background-color:#b0e0e6}</style></head><body><div class='divcanvas'><canvas id='canvas'></canvas><div class='playpause'></div></div></body><script>'use strict';console.log('Hi, it is your nft saying hello');console.log(window);const defaultShaderType=['VERTEX_SHADER','FRAGMENT_SHADER',];function createProgramFromSources(gl,as,oa,ol,oec){const shaders=[];for(let i=0;i<as.length;++i){shaders.push(loadShader(gl,as[i],gl[defaultShaderType[i]],oec));}return createProgram(gl,shaders,oa,ol,oec);}function createProgram(gl,shaders,opt_attribs,opt_locations,opt_errorCallback){const errFn=opt_errorCallback || error;const program=gl.createProgram();shaders.forEach(function(shader){gl.attachShader(program,shader);});if(opt_attribs){opt_attribs.forEach(function(attrib, ndx){gl.bindAttribLocation(program,opt_locations ? opt_locations[ndx] : ndx, attrib);});}gl.linkProgram(program);const linked=gl.getProgramParameter(program,gl.LINK_STATUS);if(!linked){const lastError=gl.getProgramInfoLog(program);errFn('Error in program linking:' + lastError);gl.deleteProgram(program);return null;}return program;}function loadShader(gl,shaderSource,shaderType,opt_errorCallback){const errFn=opt_errorCallback || error;const shader=gl.createShader(shaderType);gl.shaderSource(shader,shaderSource);gl.compileShader(shader);const compiled=gl.getShaderParameter(shader,gl.COMPILE_STATUS); return shader;}function error(msg){}function main(){const canvas=document.querySelector('#canvas');const gl=canvas.getContext('webgl2');const vs=` attribute vec4 a_position; void main() { gl_Position = a_position; } `;const fs=` precision highp float; uniform vec2 iResolution; uniform vec2 iMouse; uniform float iTime; void main() { gl_FragColor = vec4(fract((gl_FragCoord.y * iMouse) / iResolution/2), fract(iTime), 1); } `;const program=createProgramFromSources(gl,[vs, fs]);const positionAttributeLocation=gl.getAttribLocation(program,'a_position');const resolutionLocation=gl.getUniformLocation(program,'iResolution');const mouseLocation=gl.getUniformLocation(program,'iMouse');const timeLocation=gl.getUniformLocation(program,'iTime');const positionBuffer=gl.createBuffer();gl.bindBuffer(gl.ARRAY_BUFFER, positionBuffer);gl.bufferData(gl.ARRAY_BUFFER,new Float32Array([-1,-1,1,-1,-1,1,-1,1,1,-1,1,1,]),gl.STATIC_DRAW);const playpauseElem=document.querySelector('.playpause');const inputElem=document.querySelector('.divcanvas');inputElem.addEventListener('mouseover', requestFrame);inputElem.addEventListener('mouseout', cancelFrame);let mouseX=0;let mouseY=0;function setMousePosition(e){ const rect=inputElem.getBoundingClientRect();mouseX=e.clientX-rect.left;mouseY=rect.height-(e.clientY-rect.top)-1;}inputElem.addEventListener('mousemove',setMousePosition);inputElem.addEventListener('touchstart',(e)=>{e.preventDefault();playpauseElem.classList.add('playpausehide');requestFrame();},{passive: false});inputElem.addEventListener('touchmove',(e)=>{e.preventDefault();setMousePosition(e.touches[0]);},{passive: false});inputElem.addEventListener('touchend',(e)=>{ e.preventDefault();playpauseElem.classList.remove('playpausehide'); cancelFrame();},{passive: false});let requestId;function requestFrame(){if(!requestId){requestId=requestAnimationFrame(render);}}function cancelFrame(){if(requestId){cancelAnimationFrame(requestId);requestId=undefined;}}let then=0;let time=0;function render(now){requestId=undefined;now*=0.001;const elapsedTime=Math.min(now-then,0.1);time+=elapsedTime;then = now;gl.viewport(0,0,gl.canvas.width,gl.canvas.height);gl.useProgram(program);gl.enableVertexAttribArray(positionAttributeLocation);gl.bindBuffer(gl.ARRAY_BUFFER,positionBuffer);gl.vertexAttribPointer(positionAttributeLocation,2,gl.FLOAT,false,0,0,);gl.uniform2f(resolutionLocation,gl.canvas.width,gl.canvas.height);gl.uniform2f(mouseLocation,mouseX,mouseY);gl.uniform1f(timeLocation,time);gl.drawArrays(gl.TRIANGLES,0,6,);requestFrame();}requestFrame();requestAnimationFrame(cancelFrame);}main();</script></html>"

                        )
                    ),
                    
                    '"}'
                )
                
            );
    }

    function symbol() external pure returns (string memory) {
        return "SIMPLE";
    }

    function name() external pure returns (string memory) {
        return "SIMPLE ERC721";
    }

    /// @notice Check if the contract supports an interface.
    /// 0x01ffc9a7 is ERC-165.
    /// 0x80ac58cd is ERC-721
    /// 0x5b5e139f is ERC-721 Metadata (tokenURI, symbol, name)
    /// @param id The id of the interface.
    /// @return Whether the interface is supported.
    function supportsInterface(bytes4 id) public pure virtual override returns (bool) {
        return id == 0x01ffc9a7 || id == 0x80ac58cd || id == 0x5b5e139f;
    }

    function mint(uint256 num) external {
        uint256 id = _lastId;
        for (uint256 i = 0; i < num; i++) {
            id++;
            _mint(msg.sender, id);
        }
        _lastId = id;
    }
}
