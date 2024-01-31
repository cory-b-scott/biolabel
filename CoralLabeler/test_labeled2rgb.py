import numpy as np
import matplotlib.pyplot as plt
from skimage.io import imsave
def labeled2rgb(labels, color_map):
    v_get = np.vectorize(color_map.get)
    return np.stack(v_get(labels), -1).astype(np.uint8)

def circle_select(labels, labelNum, pointClicked, radius):
    h = labels.shape[0]
    w = labels.shape[1]
    Y, X = np.ogrid[:h, :w] #height, width
    #Calculate dist from center for each pt, mask according to radius to boolean
    in_circle = np.sqrt((X-pointClicked[0])**2 + (Y-pointClicked[1])**2) <=radius
    #Fill in labelNum where true
    np.place(labels, in_circle, labelNum)

color_map = {
    0: (160,160,160), #gray
    1: (153, 0, 153), #magenta
    2: (255, 0, 0), #red
    3: (0, 255, 0), #green
    4: (255, 128, 0) #orange
    }

labels = np.zeros((500,500),dtype=np.int32)
circle_select(labels, 4, (500,600), 1000)


rgb = labeled2rgb(labels,color_map)
plt.imshow(rgb)
plt.show()
