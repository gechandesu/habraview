(function(document)
{
    const onDOMBuild = () =>
    {
        // Fix blurred images
        const images = document.querySelectorAll('img[data-blurred="true"]');
        for (let image of images)
        {
            image.src = image.dataset.src;
        }
    };

    document.addEventListener('DOMContentLoaded', onDOMBuild);
})(document);
