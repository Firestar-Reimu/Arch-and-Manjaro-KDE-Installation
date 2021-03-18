// ==UserScript==
// @name         gh-proxy-buttons
// @name:zh-CN   github加速按钮
// @namespace    https://github.com/du33169/gh-proxy-buttons
// @version      1.0
// @require      https://cdn.bootcdn.net/ajax/libs/clipboard.js/2.0.6/clipboard.min.js
// @description  add a button beside github link(releases, files and repository url), click to get alternative url according to previously specified proxy.
// @description:zh-CN  为github中的特定链接（releases、文件、项目地址）添加一个悬浮按钮，提供代理后的加速链接
// @author       1900011604
// @match        *://github.com/*
// @grant        none
// @run-at       document-end
// ==/UserScript==
(function () {
	'use strict';

	/****************************代理设置*****************************/
	/**/var proxy_url = 'https://gh-proxy.du33169.workers.dev/'; /**/
	/*              备用： 'https://gh.api.99988866.xyz/';            */
	/**************代理服务器地址可自行修改，末尾斜杠不可省略！**************/

	var open_log = false;
	console.log('[gh-proxy-buttons] processing...');
	function moveHere(e, originLink)//用于注册mouseenter事件,e为当前元素
	{
		if (document.getElementById('gh-proxy-button'))//如果已经产生按钮则返回，删去在Firefox会死循环（原因未知）
		{
			return;
		}

		//创建按钮对象,github中使用.btn的class可以为<a>标签加上按钮外观
		var btn = document.createElement(e.tagName == "INPUT" ? 'button' : 'a');//对于仓库地址使用button以实现点击复制
		btn.setAttribute('class', 'btn');
		btn.id = "gh-proxy-button";
		btn.title = "get proxy link";
		btn.style.position = "absolute";
		btn.role = "button";
		btn.innerText = "🚀";
		if (e.tagName == "INPUT")//仓库地址input标签特殊处理，使用ClipboardJS实现点击复制
		{
			btn.innerText += "📄";
			new ClipboardJS(btn);
			btn.setAttribute('data-clipboard-text', proxy_url + originLink);
			console.log('[gh-proxy-buttons] input url processed');
		}
		else btn.href = proxy_url + originLink;

		e.parentNode.appendChild(btn);

		//按钮位置左上角，与原元素有小部分重叠
		var padding = Math.min(20, e.offsetHeight / 2, e.offsetWidth / 4);
		btn.style.top = (e.offsetTop - btn.offsetHeight + padding).toString() + 'px';//top等样式必须带有单位且为字符串类型
		btn.style.left = (e.offsetLeft - btn.offsetWidth + padding).toString() + 'px';

		if (open_log) console.debug('[gh-proxy-buttons] mousein');

		//以下逻辑处理鼠标移出的情况

		var onbtn = false;//鼠标移到btn上
		btn.addEventListener('mouseenter', function () {
			if (open_log) console.debug('[gh-proxy-buttons] onbtn');
			onbtn = true;
		});
		btn.addEventListener('mouseleave', function () {
			e.parentNode.removeChild(btn);
			if (open_log) console.debug('[gh-proxy-buttons] mouseleave-btn');
		});

		function emoveout() {//鼠标移出原元素
			setTimeout(function () {//setTimeout是个trick，确保在btn的mouseenter之后执行下述流程
				if (!onbtn) {
					e.parentNode.removeChild(btn);
					if (open_log) {
						console.debug('[gh-proxy-buttons] mouseleave', originLink);
						e.removeEventListener('mouseleave', emoveout);
					}
				}
			}, 3);
		}
		e.addEventListener('mouseleave', emoveout);
	}

	//releases页面的下载链接，用事件委托会出问题所以用老办法
	var aList = document.querySelectorAll('a[rel=nofollow]');
	var cnt = 0;
	for (var i = 0; i < aList.length; ++i) {
		if (/github.com/.test(aList[i].href) == true
			&& aList[i].title != "Go to parent directory") {
			if (open_log) console.log(aList[i].href);
			aList[i].addEventListener('mouseenter',
				function () {
					moveHere(Event.currentTarget, Event.currentTarget.href);
				});
			++cnt;
		}
	}
	if (cnt) {
		console.log('[gh-proxy-buttons] releases link processed');
	}
	else console.warn('[gh-proxy-buttons] releases link not found');

	if (document.querySelector(
		`#js-repo-pjax-container
		 div.container-xl.clearfix.new-discussion-timeline.px-3.px-md-4.px-lg-5
		 div.repository-content div.gutter-condensed.gutter-lg.flex-column.flex-md-row.d-flex
		 div.flex-shrink-0.col-12.col-md-9.mb-4.mb-md-0 div.file-navigation.mb-3.d-flex.flex-items-start
		 span.d-none.d-md-flex.ml-2 get-repo details.position-relative.details-overlay.details-reset
		 div.position-relative div.dropdown-menu.dropdown-menu-sw.p-0 div div.border-bottom.p-3 tab-container
		 div div.input-group input.form-control.input-monospace.input-sm.bg-gray-light`
	) == null) {
		console.error('url <input> not found');
	}

	function eventDelegation(e) {
		// e.target 是事件触发的元素
		//console.log(e.target);
		if (e.target) {
			if (open_log) console.log('[gh-proxy-buttons] ' + e.target.tagName);
			if (
				e.target.tagName == 'A'

				&& (
					e.target.getAttribute('class').indexOf("js-navigation-open") != -1
					&& e.target.parentNode.parentNode.previousElementSibling
						.querySelector('svg[aria-label=File]')//文件链接

					|| e.target.rel == "nofollow" && e.target.title != "Go to parent directory"
					&& /github.com/.test(e.target.href) == true//打包下载
				)
			) {
				moveHere(e.target, e.target.href);
			}
			else if (e.target == document.querySelector(
				`#js-repo-pjax-container
				 div.container-xl.clearfix.new-discussion-timeline.px-3.px-md-4.px-lg-5
				 div.repository-content div.gutter-condensed.gutter-lg.flex-column.flex-md-row.d-flex
				 div.flex-shrink-0.col-12.col-md-9.mb-4.mb-md-0 div.file-navigation.mb-3.d-flex.flex-items-start
				 span.d-none.d-md-flex.ml-2 get-repo details.position-relative.details-overlay.details-reset
				 div.position-relative div.dropdown-menu.dropdown-menu-sw.p-0 div div.border-bottom.p-3 tab-container
				 div div.input-group input.form-control.input-monospace.input-sm.bg-gray-light`
			))//地址input标签
			{
				moveHere(e.target, e.target.value);
			}
		}
	}
	document.getElementById('js-repo-pjax-container').addEventListener("mouseover", eventDelegation);
	//document.querySelector('.repository-content').addEventListener("mouseover", eventDelegation);
	//releases页面使用事件委托未成功，可能是冒泡机制问题

});
