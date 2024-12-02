/* eslint-disable react-native/no-inline-styles */
import React, { useState } from 'react'
import {
  LayoutAnimation,
  Platform,
  Text,
  UIManager,
  LogBox,
} from 'react-native'
import { TouchableOpacity } from 'react-native'
import { ScrollView } from 'react-native'
import { View } from 'react-native'
import { Dimensions } from 'react-native'
import { StatusBar } from 'react-native'
import { SafeAreaView } from 'react-native'

import { StyleSheet } from 'react-native'
import ImageGrid from '@baronha/react-native-image-grid'
import { openPicker, Result } from '@baronha/react-native-multiple-image-picker'

LogBox.ignoreAllLogs()

UIManager.setLayoutAnimationEnabledExperimental &&
  UIManager.setLayoutAnimationEnabledExperimental(true)

const layoutEffect = () => {
  LayoutAnimation.configureNext({
    duration: 300,
    create: {
      type: LayoutAnimation.Types.easeInEaseOut,
      property: LayoutAnimation.Properties.opacity,
    },
    update: {
      type: LayoutAnimation.Types.easeInEaseOut,
    },
  })
}

const { width } = Dimensions.get('window')

export default function App() {
  const [images, setImages] = useState<Result[]>([])

  const onPressImage = (item: Result, index: number) => {
    console.log(item, index)
  }

  const onPicker = async () => {
    try {
      const response = await openPicker({
        selectBoxStyle: 'number',
        selectedAssets: Array.isArray(images) ? images : [images],
        text: {},
        crop: {
          circle: true,
        },
      })

      console.log('response: ', response)

      setImages(Array.isArray(response) ? response : [response])
      layoutEffect()
    } catch (e) {
      console.log('e: ', e)
    }
  }

  const onRemovePhoto = (_: Result, index: number) => {
    const data = [...images].filter((_, idx) => idx !== index)
    setImages(data)
    layoutEffect()
  }

  return (
    <View style={style.container}>
      <ScrollView contentContainerStyle={{ paddingTop: 132 }}>
        <View style={{ alignItems: 'center' }}>
          <ImageGrid
            dataImage={images}
            onPressImage={onPressImage}
            // spaceSize={10}
            containerStyle={{ marginTop: 3 }}
            width={Dimensions.get('window').width - 6}
            sourceKey={'path'}
            videoKey={'type'}
            prefixPath={Platform.OS === 'ios' ? 'file://' : ''}
            conditionCheckVideo={'video'}
            videoURLKey={'thumbnail'}
            showDelete
            onDeleteImage={onRemovePhoto}
          />
          <TouchableOpacity style={style.buttonOpen} onPress={onPicker}>
            <Text style={style.textOpen}>Open Picker</Text>
          </TouchableOpacity>
        </View>
      </ScrollView>
      <View style={style.header}>
        <StatusBar barStyle={'light-content'} backgroundColor={'#000'} />
        <SafeAreaView />
        <Text style={style.title}>PICKER</Text>
      </View>
    </View>
  )
}

const style = StyleSheet.create({
  container: {
    backgroundColor: '#000',
    flex: 1,
  },
  title: {
    fontWeight: '900',
    fontSize: 24,
    paddingVertical: 24,
    fontFamily: 'Avenir',
    color: '#cdac81',
    textAlign: 'center',
  },
  buttonOpen: {
    margin: 24,
    backgroundColor: '#fff',
    padding: 12,
    alignItems: 'center',
    width: width - 48,
  },
  textOpen: {
    fontWeight: 'bold',
  },
  header: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    backgroundColor: 'rgba(0,0,0,0.9)',
  },
})
