$(function(){		
	var swiper1=new Array();
	//设计案例切换
	$('.title-list li').click(function(){
		var liindex = $('.title-list li').index(this);
		$(this).addClass('on').siblings().removeClass('on');
		$('.product-wrap div.product').eq(liindex).fadeIn(150).siblings('div.product').hide();
		var liWidth = $('.title-list li').width();
		$('.tab .title-list p').stop(false,true).animate({'left' : liindex * liWidth + 'px'},300);
		
		var len=$('.title-list > li').length;
			if(swiper1[liindex]==null){
				swiper1[liindex] = new Swiper('.swiper-container'+liindex, {
			    scrollbar: '.swiper-scrollbar'+liindex,
		        scrollbarHide: true,
		        slidesPerView: 4,
		        slidesPerGroup:4,
		        centeredSlides: false,
		        spaceBetween: 10,
		        grabCursor: true,
		        setWrapperSize :false,
		        breakpoints: { 
				    //当宽度小于等于320
				    320: {
				      slidesPerView: 4,
				      slidesPerGroup:4,
				      spaceBetweenSlides: 10
				    },
				    //当宽度小于等于376
				    375: { 
				      slidesPerView: 5,
				      slidesPerGroup:5,
				      spaceBetweenSlides: 15
				    },
				   //当宽度小于等于415
				    414: { 
				      slidesPerView: 6,
				      slidesPerGroup:6,
				      spaceBetweenSlides: 10
				    },
				     //当宽度小于等于415
				    480: { 
				      slidesPerView: 7,
				      slidesPerGroup:7,
				      spaceBetweenSlides: 10
				    },
				    //当宽度小于等于640
				    640: {
				      slidesPerView: 8,
				      slidesPerGroup:8,
				      spaceBetweenSlides: 20
			        }
			     }
		    });
		}
		
	});
	
	//设计案例hover效果
	$('.product-wrap .product li').hover(function(){
		$(this).css("border-color","#ff6600");
		$(this).find('p > a').css('color','#de374e');
	},function(){
		$(this).css("border-color","#fafafa");
		$(this).find('p > a').css('color','#666666');
	});
});